//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct ChatModel: Identifiable, Codable {
  let id: String
  let userId: String
  let avatarId: String
  let dateCreated: Date
  let dateModified: Date

  enum CodingKeys: String, CodingKey {
    case id
    case userId = "user_id"
    case avatarId = "avatar_id"
    case dateCreated = "date_created"
    case dateModified = "date_modified"
  }

  static func chatId(userId: String, avatarId: String) -> String {
    "\(userId)_\(avatarId)"
  }

  static func new(userId: String, avatarId: String) -> Self {
    let now = Date.now
    return Self(
      id: chatId(userId: userId, avatarId: avatarId),
      userId: userId,
      avatarId: avatarId,
      dateCreated: now,
      dateModified: now
    )
  }

  var eventParameters: [String: Any] {
    let ageDays = Calendar.current.dateComponents([.day], from: dateCreated, to: .now).day ?? 0
    return [
      "chat_id": id,
      "chat_avatar_id": avatarId,
      "chat_date_created": dateCreated,
      "chat_date_modified": dateModified,
      "chat_age_days": ageDays
    ]
  }
}

extension ChatModel {
  static var preview: ChatModel {
    [ChatModel].preview[0]
  }
}

extension [ChatModel] {
  static var preview: [ChatModel] {
    let now = Date()
    return [
      ChatModel(
        id: "chat_001",
        userId: "user_001",
        avatarId: "avatar_001",
        dateCreated: now.adding(days: -3),
        dateModified: now.adding(hours: -1)
      ),
      ChatModel(
        id: "chat_002",
        userId: "user_001",
        avatarId: "avatar_002",
        dateCreated: now.adding(days: -2),
        dateModified: now.adding(hours: -2)
      ),
      ChatModel(
        id: "chat_003",
        userId: "user_002",
        avatarId: "avatar_003",
        dateCreated: now.adding(days: -1),
        dateModified: now.adding(minutes: -30)
      ),
      ChatModel(
        id: "chat_004",
        userId: "user_003",
        avatarId: "avatar_004",
        dateCreated: now.adding(hours: -12),
        dateModified: now
      )
    ]
  }
}
