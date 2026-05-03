//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import UIKit

protocol AvatarService {

}

struct MockAvatarService: AvatarService {

}

struct FirebaseAvatarService: AvatarService {

}

@MainActor
@Observable
final class AvatarManager {
  private let service: any AvatarService

  init(service: any AvatarService) {
    self.service = service
  }

  func createAvatar(avatar: AvatarModel, image: UIImage) async throws {
    // TODO: Upload the image
    // TODO: Upload the avatar
  }
}
