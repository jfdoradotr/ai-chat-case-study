//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Text("Welcome!")
        .font(.largeTitle.weight(.semibold))
      Spacer()
      NavigationLink {
        OnboardingCompletedView()
      } label: {
        Text("Get Started")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.glassProminent)
      .controlSize(.large)
    }
    .padding()
  }
}

#Preview {
  NavigationStack {
    WelcomeView()
  }
}
