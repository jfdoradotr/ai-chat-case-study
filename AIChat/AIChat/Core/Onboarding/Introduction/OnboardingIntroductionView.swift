//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingIntroductionView: View {
  @Environment(LogManager.self) private var logManager

  private var avatarStyledText: Text {
    Text("avatars")
      .foregroundStyle(.accent)
      .fontWeight(.semibold)
  }

  private var realConversationsStyledText: Text {
    Text("real conversations")
      .foregroundStyle(.accent)
      .fontWeight(.semibold)
  }

  var body: some View {
    VStack {
      Text(
        "Make your own \(avatarStyledText) and chat with them!\n\nHave \(realConversationsStyledText) with AI generated responses."
      )
      .frame(maxHeight: .infinity)

      PrimaryButton(title: "Continue") {
        OnboardingColorSelectionView()
      }
      .simultaneousGesture(TapGesture().onEnded {
        logManager.trackEvent(event: OnboardingEvent.introContinuePressed)
      })
    }
    .padding(.horizontal, 24)
    .font(.title3)
    .navigationBarBackButtonHidden(true)
    .trackScreen(ScreenEvent.onboardingIntroduction)
  }
}

#Preview {
  NavigationStack {
    OnboardingIntroductionView()
  }
  .previewEnvironment()
}
