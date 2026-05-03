//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseFirestore

struct FirebaseAvatarService: RemoteAvatarService {
  var collection: CollectionReference {
    Firestore.firestore().collection("avatars")
  }

  func createAvatar(_ avatar: AvatarModel) async throws {
    try collection.document(avatar.avatarId).setData(from: avatar, merge: true)
  }
}
