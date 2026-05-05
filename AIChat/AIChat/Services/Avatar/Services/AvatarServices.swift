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
  let remote: any RemoteAvatarService = MockAvatarService()
  let image: any AvatarImageService = MockAvatarImageService()
  let local: any LocalAvatarPersistence = MockAvatarLocalPersistence()
}

@MainActor
struct ProductionAvatarServices: AvatarServices {
  let remote: any RemoteAvatarService = FirebaseAvatarService()
  let image: any AvatarImageService = SupabaseAvatarImageService()
  let local: any LocalAvatarPersistence = SwiftDataLocalAvatarPersistence()
}
