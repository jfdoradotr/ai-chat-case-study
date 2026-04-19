//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct ChatModel {
  let id: String
  let userId: String
  let avatarId: String
  let dateCreated: Date
  let dateModified: Date

  init(id: String, userId: String, avatarId: String, dateCreated: Date, dateModified: Date) {
    self.id = id
    self.userId = userId
    self.avatarId = avatarId
    self.dateCreated = dateCreated
    self.dateModified = dateModified
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
