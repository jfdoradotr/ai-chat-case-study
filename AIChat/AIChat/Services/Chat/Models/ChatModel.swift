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
        dateCreated: now.addingTimeInterval(-86400 * 3),
        dateModified: now.addingTimeInterval(-3600)
      ),
      ChatModel(
        id: "chat_002",
        userId: "user_001",
        avatarId: "avatar_002",
        dateCreated: now.addingTimeInterval(-86400 * 2),
        dateModified: now.addingTimeInterval(-7200)
      ),
      ChatModel(
        id: "chat_003",
        userId: "user_002",
        avatarId: "avatar_003",
        dateCreated: now.addingTimeInterval(-86400),
        dateModified: now.addingTimeInterval(-1800)
      ),
      ChatModel(
        id: "chat_004",
        userId: "user_003",
        avatarId: "avatar_004",
        dateCreated: now.addingTimeInterval(-43200),
        dateModified: now
      )
    ]
  }
}
