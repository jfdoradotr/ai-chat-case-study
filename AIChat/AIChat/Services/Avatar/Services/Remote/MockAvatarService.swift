//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
  func createAvatar(_ avatar: AvatarModel) async throws {}

  func getFeaturedAvatars() async throws -> [AvatarModel] {
    try await Task.sleep(for: .seconds(3))
    return .preview
  }

  func getPopularAvatars() async throws -> [AvatarModel] {
    try await Task.sleep(for: .seconds(3))
    return .preview
  }

  func getAvatars(forCategory category: AvatarModel.Character) async throws -> [AvatarModel] {
    try await Task.sleep(for: .seconds(3))
    return [AvatarModel].preview.filter { $0.character == category }
  }

  func getAvatars(forAuthorId authorId: String) async throws -> [AvatarModel] {
    try await Task.sleep(for: .seconds(3))
    return [AvatarModel].preview.filter { $0.authorId == authorId }
  }
}
