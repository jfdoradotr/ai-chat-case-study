//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import FirebaseAuth
import SwiftUI

extension EnvironmentValues {
  @Entry var authService: any AuthService = FirebaseAuthService()
}

protocol AuthService: Sendable {
  func getAuthenticatedUser() -> UserAuthInfo?
  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool)
  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool)
  func signOut() throws
  func deleteAccount() async throws
}

struct MockAuthService: AuthService {
  let currentUser: UserAuthInfo?
  let isNewUser: Bool

  init(user: UserAuthInfo? = .preview, isNewUser: Bool = false) {
    self.currentUser = user
    self.isNewUser = isNewUser
  }

  func getAuthenticatedUser() -> UserAuthInfo? {
    currentUser
  }

  func signInAnonymously() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    guard let currentUser else { throw MockError.noMockUser }
    return (currentUser, isNewUser)
  }

  func signInGoogle() async throws -> (user: UserAuthInfo, isNewUser: Bool) {
    guard let currentUser else { throw MockError.noMockUser }
    return (currentUser, isNewUser)
  }

  func signOut() throws {}

  func deleteAccount() async throws {}

  enum MockError: Error {
    case noMockUser
  }
}

struct FirebaseAuthService: AuthService {
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
        // Credential already belongs to another account: delete the anonymous user so it isn't orphaned, then sign in as the existing account below.
        try? await current.delete()
      }
    }
    let result = try await Auth.auth().signIn(with: credential)
    return (UserAuthInfo(user: result.user), result.additionalUserInfo?.isNewUser ?? false)
  }

  func signOut() throws {
    try Auth.auth().signOut()
  }

  func deleteAccount() async throws {
    guard let user = Auth.auth().currentUser else {
      throw AuthError.userNotFound
    }

    do {
      try await user.delete()
    } catch let error as NSError where error.code == AuthErrorCode.requiresRecentLogin.rawValue {
      let credential = try await reauthenticationCredential(for: user)
      try await user.reauthenticate(with: credential)
      try await user.delete()
    }
  }

  private func reauthenticationCredential(for user: User) async throws -> AuthCredential {
    let providerIDs = user.providerData.map(\.providerID)
    if providerIDs.contains("google.com") {
      let google = try await SignInWithGoogleHelper().signIn()
      return GoogleAuthProvider.credential(
        withIDToken: google.idToken,
        accessToken: google.accessToken
      )
    }
    throw AuthError.unsupportedReauthentication
  }

  enum AuthError: LocalizedError {
    case userNotFound
    case unsupportedReauthentication

    var errorDescription: String? {
      switch self {
      case .userNotFound:
        return "Current authenticated user not found."

      case .unsupportedReauthentication:
        return "No supported provider available to re-authenticate this account."
      }
    }
  }
}
