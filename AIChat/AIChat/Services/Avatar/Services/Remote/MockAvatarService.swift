//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

struct MockAvatarService: RemoteAvatarService {
  func createAvatar(_ avatar: AvatarModel) async throws {}
}
