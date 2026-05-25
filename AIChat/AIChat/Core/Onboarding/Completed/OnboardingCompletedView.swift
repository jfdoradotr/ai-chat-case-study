//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingCompletedView: View {
  @Environment(AppState.self) private var appState
  @Environment(UserManager.self) private var userManager
  @Environment(LogManager.self) private var logManager

  @State private var isCompletingProfileSetup = false
  @State private var errorMessage: String?

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
    .alert(
      "Something went wrong",
      isPresented: Binding(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      ),
      presenting: errorMessage
    ) { _ in
      Button("OK", role: .cancel) {}
    } message: { message in
      Text(message)
    }
    .trackScreen(ScreenEvent.onboardingCompleted)
  }

  private func onFinishButtonPressed() {
    isCompletingProfileSetup = true
    let hex = selectedColor.asHex() ?? "FF5757"
    logManager.trackEvent(event: OnboardingEvent.finishPressed)
    Task {
      defer { isCompletingProfileSetup = false }
      logManager.trackEvent(event: OnboardingEvent.completeOnboardingStart)
      do {
        try await userManager.markOnboardingCompleteForCurrentUser(profileColorHex: hex)
        logManager.trackEvent(event: OnboardingEvent.completeOnboardingSuccess(hex: hex))
        appState.updateViewState(showTabBar: true)
      } catch {
        errorMessage = "Failed to complete onboarding: \(error.localizedDescription)"
        logManager.trackEvent(event: OnboardingEvent.completeOnboardingFailure(error: error))
      }
    }
  }
}

#Preview {
  NavigationStack {
    OnboardingCompletedView(selectedColor: .orange)
  }
  .previewEnvironment()
}
