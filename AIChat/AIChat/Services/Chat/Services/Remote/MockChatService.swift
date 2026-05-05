//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

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

  func createChat(_ chat: ChatModel) async throws {
    try await simulate()
  }

  func addMessage(_ message: ChatMessageModel, chatId: String) async throws {
    try await simulate()
  }
}
