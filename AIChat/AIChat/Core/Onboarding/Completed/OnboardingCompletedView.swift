//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingCompletedView: View {
  @Environment(AppState.self) private var appState
  @Environment(UserManager.self) private var userManager

  @State private var isCompletingProfileSetup = false

  let selectedColor: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Setup complete!")
        .font(.largeTitle.weight(.semibold))
        .foregroundStyle(selectedColor)
      Text("We've set up your profile and you're ready to start chatting.")
        .font(.title.weight(.medium))
        .foregroundStyle(.secondary)
    }
    .navigationBarBackButtonHidden(true)
    .frame(maxHeight: .infinity)
    .safeAreaInset(edge: .bottom) {
      PrimaryButton(
        title: "Finish",
        isLoading: isCompletingProfileSetup,
        action: onFinishButtonPressed
      )
    }
    .padding(24)
  }

  private func onFinishButtonPressed() {
    isCompletingProfileSetup = true
    Task {
      try await userManager.markOnboardingCompleteForCurrentUser(profileColorHex: selectedColor.asHex() ?? "FF5757")
      isCompletingProfileSetup = false
      appState.updateViewState(showTabBar: true)
    }
  }
}

#Preview {
  NavigationStack {
    OnboardingCompletedView(selectedColor: .orange)
  }
  .environment(AppState())
  .environment(UserManager(service: MockUserService(user: .preview)))
}
