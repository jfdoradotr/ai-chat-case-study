//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppViewBuilder<TabBarView: View, OnboardingView: View>: View {
  let showTabBar: Bool
  @ViewBuilder let tabBarView: TabBarView
  @ViewBuilder let onboardingView: OnboardingView

  var body: some View {
    ZStack {
      if showTabBar {
        tabBarView
          .transition(.move(edge: .trailing))
      } else {
        onboardingView
          .transition(.move(edge: .leading))
      }
    }
    .animation(.smooth, value: showTabBar)
  }
}
