//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

protocol RemoteChatService: Sendable {
  func getChat(userId: String, avatarId: String) async throws -> ChatModel?
  func createChat(_ chat: ChatModel) async throws
  func addMessage(_ message: ChatMessageModel, chatId: String) async throws
  func getMessages(forChatId chatId: String) async throws -> [ChatMessageModel]
}
