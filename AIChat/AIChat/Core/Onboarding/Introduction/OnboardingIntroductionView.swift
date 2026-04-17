//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingIntroductionView: View {
  var body: some View {
    VStack {
      Group {
        Text("Make your own ")
        + Text("avatars ")
          .foregroundStyle(.accent)
          .fontWeight(.semibold)
        + Text("and chat with them!\n\nHave ")
        + Text("real conversations ")
          .foregroundStyle(.accent)
          .fontWeight(.semibold)
        + Text("with AI generated responses.")
      }
      .frame(maxHeight: .infinity)

      NavigationLink {
        OnboardingCompletedView()
      } label: {
        Text("Get Started")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.glassProminent)
      .controlSize(.large)
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  NavigationStack {
    OnboardingIntroductionView()
  }
}
