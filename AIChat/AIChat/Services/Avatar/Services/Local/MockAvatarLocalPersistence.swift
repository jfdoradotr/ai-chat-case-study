//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

actor MockAvatarLocalPersistence: LocalAvatarPersistence {
  private var avatars: [AvatarModel]

  init(avatars: [AvatarModel] = []) {
    self.avatars = avatars
  }

  func addRecentAvatar(_ avatar: AvatarModel) async throws {
    avatars.removeAll { $0.avatarId == avatar.avatarId }
    avatars.insert(avatar, at: 0)
  }

  func getRecentAvatars() async throws -> [AvatarModel] {
    avatars
  }
}
