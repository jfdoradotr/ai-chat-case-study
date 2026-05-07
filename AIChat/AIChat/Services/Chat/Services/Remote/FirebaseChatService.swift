//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore

struct FirebaseChatService: RemoteChatService {
  var collection: CollectionReference {
    Firestore.firestore().collection("chats")
  }

  private func messagesCollection(for chatId: String) -> CollectionReference {
    collection.document(chatId).collection("messages")
  }

  func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
    let id = ChatModel.chatId(userId: userId, avatarId: avatarId)
    let document = try await collection.document(id).getDocument()
    guard document.exists else { return nil }
    return try document.data(as: ChatModel.self)
  }

  func getAllChats(userId: String) async throws -> [ChatModel] {
    let snapshot = try await collection
      .whereField(ChatModel.CodingKeys.userId.rawValue, isEqualTo: userId)
      .order(by: ChatModel.CodingKeys.dateModified.rawValue, descending: true)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: ChatModel.self) }
  }

  func createChat(_ chat: ChatModel) async throws {
    try collection.document(chat.id).setData(from: chat, merge: true)
  }

  func deleteChat(chatId: String) async throws {
    let messagesSnapshot = try await messagesCollection(for: chatId).getDocuments()
    let batch = Firestore.firestore().batch()
    for doc in messagesSnapshot.documents {
      batch.deleteDocument(doc.reference)
    }
    batch.deleteDocument(collection.document(chatId))
    try await batch.commit()
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try messagesCollection(for: chatId).document(message.id).setData(from: message, merge: true)
    try await collection.document(chatId).updateData([
      ChatModel.CodingKeys.dateModified.rawValue: FieldValue.serverTimestamp()
    ])
  }

  func getMessages(forChatId chatId: String) async throws -> [ChatMessageModel] {
    let snapshot = try await messagesCollection(for: chatId)
      .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: false)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: ChatMessageModel.self) }
  }

  func getLastMessage(forChatId chatId: String) async throws -> ChatMessageModel? {
    let snapshot = try await messagesCollection(for: chatId)
      .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: true)
      .limit(to: 1)
      .getDocuments()
    return snapshot.documents.first.flatMap { try? $0.data(as: ChatMessageModel.self) }
  }

  func streamMessages(
    forChatId chatId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<[ChatMessageModel], any Error> {
    AsyncThrowingStream { continuation in
      let listener = messagesCollection(for: chatId)
        .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: false)
        .addSnapshotListener { snapshot, error in
          if let error {
            continuation.finish(throwing: error)
            return
          }
          guard let snapshot else {
            continuation.yield([])
            return
          }
          let messages = snapshot.documents.compactMap { try? $0.data(as: ChatMessageModel.self) }
          continuation.yield(messages)
        }
      onListenerConfigured(listener)
      continuation.onTermination = { _ in
        listener.remove()
      }
    }
  }

  func streamAllChats(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<[ChatModel], any Error> {
    AsyncThrowingStream { continuation in
      let listener = collection
        .whereField(ChatModel.CodingKeys.userId.rawValue, isEqualTo: userId)
        .order(by: ChatModel.CodingKeys.dateModified.rawValue, descending: true)
        .addSnapshotListener { snapshot, error in
          if let error {
            continuation.finish(throwing: error)
            return
          }
          guard let snapshot else {
            continuation.yield([])
            return
          }
          let chats = snapshot.documents.compactMap { try? $0.data(as: ChatModel.self) }
          continuation.yield(chats)
        }
      onListenerConfigured(listener)
      continuation.onTermination = { _ in
        listener.remove()
      }
    }
  }
}
