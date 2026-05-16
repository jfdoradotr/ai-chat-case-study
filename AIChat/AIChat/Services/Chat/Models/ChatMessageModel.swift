//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct ChatMessageModel: Identifiable, Codable {
  let id: String
  let chatId: String
  let authorId: String?
  let content: String?
  let dateCreated: Date?

  enum CodingKeys: String, CodingKey {
    case id
    case chatId = "chat_id"
    case authorId = "author_id"
    case content
    case dateCreated = "date_created"
  }

  init(
    id: String,
    chatId: String,
    authorId: String? = nil,
    content: String? = nil,
    dateCreated: Date? = nil
  ) {
    self.id = id
    self.chatId = chatId
    self.authorId = authorId
    self.content = content
    self.dateCreated = dateCreated
  }

  static func newUserMessage(chatId: String, userId: String, content: String) -> Self {
    Self(
      id: UUID().uuidString,
      chatId: chatId,
      authorId: userId,
      content: content,
      dateCreated: .now
    )
  }

  static func newAIMessage(chatId: String, avatarId: String, content: String) -> Self {
    Self(
      id: UUID().uuidString,
      chatId: chatId,
      authorId: avatarId,
      content: content,
      dateCreated: .now
    )
  }

  var eventParameters: [String: Any] {
    var params: [String: Any] = [
      "message_id": id,
      "message_chat_id": chatId,
      "message_content_length": content?.count ?? 0
    ]
    if let dateCreated {
      params["message_date_created"] = dateCreated
    }
    return params
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
        dateCreated: now.adding(hours: -3)
      ),
      ChatMessageModel(
        id: "msg_002",
        chatId: "chat_001",
        authorId: "user_002",
        content: "I'm great, thanks for asking! Just working on some SwiftUI stuff.",
        dateCreated: now.adding(hours: -2, minutes: -45)
      ),
      ChatMessageModel(
        id: "msg_003",
        chatId: "chat_001",
        authorId: "user_001",
        content: "That sounds cool! What are you building?",
        dateCreated: now.adding(hours: -2)
      ),
      ChatMessageModel(
        id: "msg_004",
        chatId: "chat_001",
        authorId: "user_002",
        content: "An AI chat app with custom avatars. It's been a fun challenge!",
        dateCreated: now.adding(minutes: -30)
      )
    ]
  }
}
