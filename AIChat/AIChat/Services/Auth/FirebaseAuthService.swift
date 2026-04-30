//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth

struct FirebaseAuthService {
  func getAuthenticatedUser() -> User? {
    if let user = Auth.auth().currentUser {
      return user
    }
    return nil
  }

  func signInAnonymously() async throws -> AuthDataResult {
    try await Auth.auth().signInAnonymously()
  }
}
