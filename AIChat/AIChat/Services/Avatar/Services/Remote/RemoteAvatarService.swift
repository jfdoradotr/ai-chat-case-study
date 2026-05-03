//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation

protocol RemoteAvatarService: Sendable {
  func createAvatar(_ avatar: AvatarModel) async throws
}
