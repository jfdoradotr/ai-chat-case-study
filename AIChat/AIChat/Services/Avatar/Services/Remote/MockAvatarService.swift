//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
  let avatars: [AvatarModel]
  let delay: Double
  let shouldThrow: Bool

  init(
    avatars: [AvatarModel] = .preview,
    delay: Double = 1,
    shouldThrow: Bool = false
  ) {
    self.avatars = avatars
    self.delay = delay
    self.shouldThrow = shouldThrow
  }

  private func simulate() async throws {
    try await Task.sleep(for: .seconds(delay))
    if shouldThrow {
      throw URLError(.notConnectedToInternet)
    }
  }

  func createAvatar(_ avatar: AvatarModel) async throws {}

  func getAvatar(id: String) async throws -> AvatarModel {
    try await simulate()
    guard let avatar = avatars.first(where: { $0.avatarId == id }) else {
      return .preview
    }
    return avatar
  }

  func getFeaturedAvatars() async throws -> [AvatarModel] {
    try await simulate()
    return avatars
  }

  func getPopularAvatars() async throws -> [AvatarModel] {
    try await simulate()
    return avatars
  }

  func getAvatars(forCategory category: AvatarModel.Character) async throws -> [AvatarModel] {
    try await simulate()
    return avatars.filter { $0.character == category }
  }

  func getAvatars(forAuthorId authorId: String) async throws -> [AvatarModel] {
    try await simulate()
    return avatars.filter { $0.authorId == authorId }
  }

  func incrementClickCount(forAvatarId avatarId: String) async throws {}
}
