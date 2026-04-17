//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingCompletedView: View {
  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Text("Onboarding Completed!")
        .font(.largeTitle.weight(.semibold))
      Spacer()
      Button {
        // TODO: Finish onboarding and enter app
      } label: {
        Text("Finish")
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
    OnboardingCompletedView()
  }
}
