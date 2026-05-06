//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

@MainActor
@Observable
final class ChatManager {
  private let remote: any RemoteChatService

  init(services: any ChatServices) {
    self.remote = services.remote
  }

  func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
    try await remote.getChat(userId: userId, avatarId: avatarId)
  }

  func createChat(_ chat: ChatModel) async throws {
    try await remote.createChat(chat)
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try await remote.addMessage(message, chatId: chatId)
  }

  func getMessages(forChatId chatId: String) async throws -> [ChatMessageModel] {
    try await remote.getMessages(forChatId: chatId)
  }

  func streamMessages(forChatId chatId: String) -> AsyncThrowingStream<[ChatMessageModel], any Error> {
    remote.streamMessages(forChatId: chatId, onListenerConfigured: { _ in })
  }
}
