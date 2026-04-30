//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import GoogleSignIn
import UIKit

struct SignInWithGoogleResult {
  let idToken: String
  let accessToken: String
  let email: String?
  let fullName: String?
}

enum SignInWithGoogleError: LocalizedError {
  case noRootViewController
  case missingIdToken

  var errorDescription: String? {
    switch self {
    case .noRootViewController:
      return "No active window found to present Google Sign-In."
    case .missingIdToken:
      return "Google Sign-In did not return an ID token."
    }
  }
}

@MainActor
final class SignInWithGoogleHelper {
  func signIn() async throws -> SignInWithGoogleResult {
    guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
          let rootViewController = scene.windows.first(where: \.isKeyWindow)?.rootViewController
    else {
      throw SignInWithGoogleError.noRootViewController
    }

    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
    guard let idToken = result.user.idToken?.tokenString else {
      throw SignInWithGoogleError.missingIdToken
    }

    return SignInWithGoogleResult(
      idToken: idToken,
      accessToken: result.user.accessToken.tokenString,
      email: result.user.profile?.email,
      fullName: result.user.profile?.name
    )
  }
}
