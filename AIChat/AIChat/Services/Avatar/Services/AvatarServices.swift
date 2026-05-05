//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol AvatarServices {
  var remote: any RemoteAvatarService { get }
  var image: any AvatarImageService { get }
  var local: any LocalAvatarPersistence { get }
}

@MainActor
struct MockAvatarServices: AvatarServices {
  let remote: any RemoteAvatarService
  let image: any AvatarImageService
  let local: any LocalAvatarPersistence

  init(
    remote: any RemoteAvatarService = MockAvatarService(),
    image: any AvatarImageService = MockAvatarImageService(),
    local: any LocalAvatarPersistence = MockAvatarLocalPersistence()
  ) {
    self.remote = remote
    self.image = image
    self.local = local
  }
}

@MainActor
struct ProductionAvatarServices: AvatarServices {
  let remote: any RemoteAvatarService = FirebaseAvatarService()
  let image: any AvatarImageService = SupabaseAvatarImageService()
  let local: any LocalAvatarPersistence = SwiftDataLocalAvatarPersistence()
}
