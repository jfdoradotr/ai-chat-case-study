//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol LocalAvatarPersistence: Sendable {
  func addRecentAvatar(_ avatar: AvatarModel) async throws
  func getRecentAvatars() async throws -> [AvatarModel]
}
