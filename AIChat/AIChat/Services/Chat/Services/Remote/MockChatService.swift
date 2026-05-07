//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore
import Foundation

struct MockChatService: RemoteChatService {
  let chats: [ChatModel]
  let delay: Double
  let shouldThrow: Bool

  init(chats: [ChatModel] = [], delay: Double = 0, shouldThrow: Bool = false) {
    self.chats = chats
    self.delay = delay
    self.shouldThrow = shouldThrow
  }

  private func simulate() async throws {
    if delay > 0 { try await Task.sleep(for: .seconds(delay)) }
    if shouldThrow { throw URLError(.notConnectedToInternet) }
  }

  func getChat(userId: String, avatarId: String) async throws -> ChatModel? {
    try await simulate()
    return chats.first(where: { $0.userId == userId && $0.avatarId == avatarId })
  }

  func getAllChats(userId: String) async throws -> [ChatModel] {
    try await simulate()
    return chats.filter { $0.userId == userId }
  }

  func createChat(_ chat: ChatModel) async throws {
    try await simulate()
  }

  func deleteChat(chatId: String) async throws {
    try await simulate()
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try await simulate()
  }

  func getMessages(forChatId chatId: String) async throws -> [ChatMessageModel] {
    try await simulate()
    return []
  }

  func getLastMessage(forChatId chatId: String) async throws -> ChatMessageModel? {
    try await simulate()
    return nil
  }

  func streamMessages(
    forChatId chatId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<[ChatMessageModel], any Error> {
    AsyncThrowingStream { continuation in
      continuation.yield([])
    }
  }

  func streamAllChats(
    userId: String,
    onListenerConfigured: (any ListenerRegistration) -> Void
  ) -> AsyncThrowingStream<[ChatModel], any Error> {
    AsyncThrowingStream { continuation in
      continuation.yield(chats.filter { $0.userId == userId })
    }
  }
}
