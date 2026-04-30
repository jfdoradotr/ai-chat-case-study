//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth
import SwiftUI

extension EnvironmentValues {
  @Entry var authService = FirebaseAuthService()
}

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

struct FirebaseAuthService {
  func getAuthenticatedUser() -> UserAuthInfo? {
    if let user = Auth.auth().currentUser {
      return UserAuthInfo(user: user)
    }
    return nil
  }

  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    let result = try await Auth.auth().signInAnonymously()
    let user = UserAuthInfo(user: result.user)
    let isNewUser = result.additionalUserInfo?.isNewUser ?? true
    return (user, isNewUser)
  }
}
