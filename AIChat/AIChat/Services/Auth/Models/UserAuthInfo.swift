//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth

struct UserAuthInfo {
  let uid: String
  let email: String?
  let isAnonymous: Bool
  let creationDate: Date?
  let lastSignInDate: Date?
}

extension UserAuthInfo {
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.isAnonymous = user.isAnonymous
    self.creationDate = user.metadata.creationDate
    self.lastSignInDate = user.metadata.lastSignInDate
  }
}
