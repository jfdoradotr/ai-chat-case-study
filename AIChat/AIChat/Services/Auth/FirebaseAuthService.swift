//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth
import SwiftUI

extension EnvironmentValues {
  @Entry var authService = FirebaseAuthService()
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
