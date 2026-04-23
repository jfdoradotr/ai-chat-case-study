//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  @State private var showSignIn = false

  var body: some View {
    VStack(spacing: 0) {
      ImageLoaderView(url: Constants.randomImageURL)
        .ignoresSafeArea()
      VStack(spacing: 16) {
        Text("AI Chat 🤖")
          .font(.largeTitle.weight(.bold))
          .accessibilityAddTraits(.isHeader)
        Text("Website @ SwiftyJourney.com")
          .font(.caption)
          .foregroundStyle(.secondary)
        PrimaryButton(title: "Get Started") {
          OnboardingIntroductionView()
        }

        Button("Already have an account? Sign in", action: onSignInPressed)
          .underline()
        HStack(spacing: 8) {
          Button("Terms of Service") {}
          Circle()
            .fill(.accent)
            .frame(width: 4, height: 4)
            .accessibilityHidden(true)
          Button("Privacy Policy") {}
        }
        .font(.caption)
        .padding(.top, 16)
      }
      .padding()
    }
    .sheet(isPresented: $showSignIn) {
      CreateAccountView()
        .presentationDetents([.medium])
    }
  }

  private func onSignInPressed() {
    showSignIn = true
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
  }
}
