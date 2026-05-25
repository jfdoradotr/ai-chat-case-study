//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  @Environment(LogManager.self) private var logManager

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
        .simultaneousGesture(TapGesture().onEnded {
          logManager.trackEvent(event: WelcomeEvent.getStartedPressed)
        })

        Button("Already have an account? Sign in", action: onSignInPressed)
          .underline()
        HStack(spacing: 8) {
          Button("Terms of Service") {
            logManager.trackEvent(event: WelcomeEvent.termsOfServicePressed)
          }
          Circle()
            .fill(.accent)
            .frame(width: 4, height: 4)
            .accessibilityHidden(true)
          Button("Privacy Policy") {
            logManager.trackEvent(event: WelcomeEvent.privacyPolicyPressed)
          }
        }
        .font(.caption)
        .padding(.top, 16)
      }
      .padding()
    }
    .sheet(isPresented: $showSignIn) {
      CreateAccountView(presentationState: .signIn)
        .presentationDetents([.medium])
    }
    .trackScreen(ScreenEvent.welcome)
  }

  private func onSignInPressed() {
    logManager.trackEvent(event: WelcomeEvent.signInPressed)
    showSignIn = true
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
  }
  .previewEnvironment()
}
