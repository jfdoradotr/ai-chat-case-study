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

  func createChat(_ chat: ChatModel) async throws {
    try collection.document(chat.id).setData(from: chat, merge: true)
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try messagesCollection(for: chatId).document(message.id).setData(from: message, merge: true)
  }

  func getMessages(forChatId chatId: String) async throws -> [ChatMessageModel] {
    let snapshot = try await messagesCollection(for: chatId)
      .order(by: ChatMessageModel.CodingKeys.dateCreated.rawValue, descending: false)
      .getDocuments()
    return snapshot.documents.compactMap { try? $0.data(as: ChatMessageModel.self) }
  }
}
