//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import AuthenticationServices
import SwiftUI

struct CreateAccountView: View {
  enum PresentationState {
    case signIn
    case createAccount

    var title: String {
      switch self {
      case .signIn:
        return "Sign in!"

      case .createAccount:
        return "Create Account?"
      }
    }

    var subtitle: String {
      switch self {
      case .signIn:
        return "Connect to an existing account."

      case .createAccount:
        return "Don't lose your data!. Connect to an SSO provider to save your account."
      }
    }
  }

  let presentationState: PresentationState

  var body: some View {
    VStack(spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text(presentationState.title)
          .font(.largeTitle.weight(.semibold))
        Text(presentationState.subtitle)
          .font(.body)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      SignInWithAppleButton(presentationState == .signIn ? .signIn : .signUp) { request in
        request.requestedScopes = [.fullName, .email]
      } onCompletion: { result in
        switch result {
        case .success(let authorization):
          handleSignInWithApple(authorization)

        case .failure(let error):
          print("Sign in with Apple failed: \(error.localizedDescription)")
        }
      }
      .frame(height: 50)
      .signInWithAppleButtonStyle(.black)

      Spacer()
    }
    .padding(16)
    .padding(.top, 40)
  }

  private func handleSignInWithApple(_ authorization: ASAuthorization) {
    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
      let userId = credential.user
      let fullName = credential.fullName
      let email = credential.email
      print("User ID: \(userId)")
      print("Full Name: \(fullName?.givenName ?? "N/A")")
      print("Email: \(email ?? "N/A")")
    }
  }
}

#Preview {
  CreateAccountView(presentationState: .createAccount)
}
