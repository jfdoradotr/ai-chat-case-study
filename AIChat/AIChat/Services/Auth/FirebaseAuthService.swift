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

  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    let google = try await SignInWithGoogleHelper().signIn()
    let credential = GoogleAuthProvider.credential(
      withIDToken: google.idToken,
      accessToken: google.accessToken
    )
    return try await signIn(credential: credential)
  }

  private func signIn(credential: AuthCredential) async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    if let current = Auth.auth().currentUser, current.isAnonymous {
      do {
        let result = try await current.link(with: credential)
        return (UserAuthInfo(user: result.user), result.additionalUserInfo?.isNewUser ?? false)
      } catch let error as NSError where error.code == AuthErrorCode.credentialAlreadyInUse.rawValue {
        // Credential ya pertenece a otra cuenta Firebase: descartamos el anónimo y entramos como esa cuenta.
      }
    }
    let result = try await Auth.auth().signIn(with: credential)
    return (UserAuthInfo(user: result.user), result.additionalUserInfo?.isNewUser ?? false)
  }
}
