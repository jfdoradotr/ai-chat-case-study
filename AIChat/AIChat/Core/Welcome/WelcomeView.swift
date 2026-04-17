//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  var body: some View {
    VStack {
      Rectangle()
        .ignoresSafeArea()

      VStack(spacing: 16) {
        Text("AI Chat 🤖")
          .font(.largeTitle.weight(.bold))
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
        HStack {
          Button("Terms of Service") {}
          Circle()
            .fill(.accent)
            .frame(width: 6, height: 6)
          Button("Privacy Policy") {}
        }
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
