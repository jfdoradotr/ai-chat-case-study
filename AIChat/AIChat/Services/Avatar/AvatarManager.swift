//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

@MainActor
@Observable
final class AvatarManager {
  private let remote: any RemoteAvatarService
  private let image: any AvatarImageService

  init(services: any AvatarServices) {
    self.remote = services.remote
    self.image = services.image
  }

  func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
    let url = try await self.image.uploadAvatarImage(image, path: "\(avatar.avatarId).jpg")
    let avatarWithURL = avatar.withImageURL(url)
    try await remote.createAvatar(avatarWithURL)
  }

  func getAvatar(id: String) async throws -> AvatarModel {
    try await remote.getAvatar(id: id)
  }

  func getFeaturedAvatars() async throws -> [AvatarModel] {
    try await remote.getFeaturedAvatars()
  }

  func getPopularAvatars() async throws -> [AvatarModel] {
    try await remote.getPopularAvatars()
  }

  func getAvatars(forCategory category: AvatarModel.Character) async throws -> [AvatarModel] {
    try await remote.getAvatars(forCategory: category)
  }

  func getAvatars(forAuthorId authorId: String) async throws -> [AvatarModel] {
    try await remote.getAvatars(forAuthorId: authorId)
  }
}
