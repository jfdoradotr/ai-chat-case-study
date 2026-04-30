//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

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

    var googleButtonTitle: String {
      switch self {
      case .signIn:
        return "Sign in with Google"
      case .createAccount:
        return "Sign up with Google"
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

      Button(action: onGoogleButtonPressed) {
        HStack {
          Image(systemName: "g.circle.fill")
          Text(presentationState.googleButtonTitle)
            .font(.headline)
        }
        .foregroundStyle(.black)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(.gray.opacity(0.3), lineWidth: 1)
        )
      }

      Spacer()
    }
    .padding(16)
    .padding(.top, 40)
  }

  private func onGoogleButtonPressed() {
    Task {
      do {
        let result = try await SignInWithGoogleHelper().signIn()
        print("Google sign-in OK — idToken: \(result.idToken.prefix(20))…, email: \(result.email ?? "n/a")")
      } catch {
        print("Google sign-in failed: \(error.localizedDescription)")
      }
    }
  }
}

#Preview {
  CreateAccountView(presentationState: .createAccount)
}
