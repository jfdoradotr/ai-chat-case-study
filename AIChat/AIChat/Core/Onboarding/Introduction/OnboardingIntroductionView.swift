//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingIntroductionView: View {
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
    }
    .padding(.horizontal, 24)
  }
}

#Preview {
  NavigationStack {
    OnboardingIntroductionView()
  }
}
