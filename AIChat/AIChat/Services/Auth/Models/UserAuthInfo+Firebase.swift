//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth

extension UserAuthInfo {
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.isAnonymous = user.isAnonymous
    self.creationDate = user.metadata.creationDate
    self.lastSignInDate = user.metadata.lastSignInDate
  }
}
