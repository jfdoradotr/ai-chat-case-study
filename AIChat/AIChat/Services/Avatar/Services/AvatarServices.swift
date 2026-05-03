//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

protocol AvatarServices {
  var remote: any RemoteAvatarService { get }
  var image: any AvatarImageService { get }
}

struct MockAvatarServices: AvatarServices {
  let remote: any RemoteAvatarService = MockAvatarService()
  let image: any AvatarImageService = MockAvatarImageService()
}

struct ProductionAvatarServices: AvatarServices {
  let remote: any RemoteAvatarService = FirebaseAvatarService()
  let image: any AvatarImageService = SupabaseAvatarImageService()
}
