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
    let snapshot = try await collection
      .whereField(ChatModel.CodingKeys.userId.rawValue, isEqualTo: userId)
      .whereField(ChatModel.CodingKeys.avatarId.rawValue, isEqualTo: avatarId)
      .limit(to: 1)
      .getDocuments()
    return snapshot.documents.first.flatMap { try? $0.data(as: ChatModel.self) }
  }

  func createChat(_ chat: ChatModel) async throws {
    try collection.document(chat.id).setData(from: chat, merge: true)
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try messagesCollection(for: chatId).document(message.id).setData(from: message, merge: true)
  }
}
