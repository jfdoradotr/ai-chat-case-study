//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

protocol RemoteAvatarService: Sendable {
  func createAvatar(_ avatar: AvatarModel) async throws
  func getFeaturedAvatars() async throws -> [AvatarModel]
  func getPopularAvatars() async throws -> [AvatarModel]
  func getAvatars(forCategory category: AvatarModel.Character) async throws -> [AvatarModel]
}
