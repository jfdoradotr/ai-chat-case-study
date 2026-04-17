//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingCompletedView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    VStack(spacing: 24) {
      Spacer()
      Text("Onboarding Completed!")
        .font(.largeTitle.weight(.semibold))
      Spacer()
      Button(action: onFinishButtonPressed) {
        Text("Finish")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.glassProminent)
      .controlSize(.large)
    }
    .padding()
  }

  private func onFinishButtonPressed() {
    appState.updateViewState(showTabBar: true)
  }
}

#Preview {
  NavigationStack {
    OnboardingCompletedView()
      .environment(AppState())
  }
}
