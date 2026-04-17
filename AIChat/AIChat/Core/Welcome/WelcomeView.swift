//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  var body: some View {
    VStack(spacing: 0) {
      Rectangle()
        .fill(.accent.opacity(0.3))
        .ignoresSafeArea()

      VStack(spacing: 16) {
        Text("AI Chat 🤖")
          .font(.largeTitle.weight(.bold))
          .accessibilityAddTraits(.isHeader)
        Text("Website @ SwiftyJourney.com")
          .font(.caption)
          .foregroundStyle(.secondary)
        NavigationLink {
          OnboardingCompletedView()
        } label: {
          Text("Get Started")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.glassProminent)
        .controlSize(.large)

        Button("Already have an account? Sign in") {}
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
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
  }
}
