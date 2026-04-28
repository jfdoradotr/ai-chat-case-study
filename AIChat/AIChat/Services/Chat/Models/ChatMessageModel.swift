//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct ChatMessageModel: Identifiable {
  let id: String
  let chatId: String
  let authorId: String?
  let content: String?
  let seenByIds: [String]
  let dateCreated: Date?

  init(
    id: String,
    chatId: String,
    authorId: String? = nil,
    content: String? = nil,
    seenByIds: [String] = [],
    dateCreated: Date? = nil
  ) {
    self.id = id
    self.chatId = chatId
    self.authorId = authorId
    self.content = content
    self.seenByIds = seenByIds
    self.dateCreated = dateCreated
  }

  func hasBeenSeenByCurrentUser(userId: String) -> Bool {
    guard seenByIds.isEmpty else { return false }
    return seenByIds.contains(userId)
  }
}

extension ChatMessageModel {
  static var preview: ChatMessageModel {
    [ChatMessageModel].preview[0]
  }
}

extension [ChatMessageModel] {
  static var preview: [ChatMessageModel] {
    let now = Date()
    return [
      ChatMessageModel(
        id: "msg_001",
        chatId: "chat_001",
        authorId: "user_001",
        content: "Hey! How are you doing today?",
        seenByIds: ["user_001", "user_002"],
        dateCreated: now.adding(hours: -3)
      ),
      ChatMessageModel(
        id: "msg_002",
        chatId: "chat_001",
        authorId: "user_002",
        content: "I'm great, thanks for asking! Just working on some SwiftUI stuff.",
        seenByIds: ["user_001", "user_002"],
        dateCreated: now.adding(hours: -2, minutes: -45)
      ),
      ChatMessageModel(
        id: "msg_003",
        chatId: "chat_001",
        authorId: "user_001",
        content: "That sounds cool! What are you building?",
        seenByIds: ["user_002"],
        dateCreated: now.adding(hours: -2)
      ),
      ChatMessageModel(
        id: "msg_004",
        chatId: "chat_001",
        authorId: "user_002",
        content: "An AI chat app with custom avatars. It's been a fun challenge!",
        seenByIds: ["user_001"],
        dateCreated: now.adding(minutes: -30)
      )
    ]
  }
}
