//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import AuthenticationServices
import SwiftUI

struct CreateAccountView: View {
  var body: some View {
    VStack(spacing: 24) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Create Account?")
          .font(.largeTitle.weight(.semibold))
        Text("Don't lose your data!. Connect to an SSO provider to save your account.")
          .font(.body)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      SignInWithAppleButton(.signIn) { request in
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
  CreateAccountView()
}
