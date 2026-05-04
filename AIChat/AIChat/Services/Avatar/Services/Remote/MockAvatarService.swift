//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
  func createAvatar(_ avatar: AvatarModel) async throws {}

  func getFeaturedAvatars() async throws -> [AvatarModel] {
    .preview
  }

  func getPopularAvatars() async throws -> [AvatarModel] {
    .preview
  }
}
