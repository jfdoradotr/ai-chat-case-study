//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @State private var appState = AppState()

  var body: some View {
    AppViewBuilder(
      showTabBar: appState.showTabBar,
      tabBarView: {
        TabBarView()
      },
      onboardingView: {
        NavigationStack {
          WelcomeView()
        }
      }
    )
    .environment(appState)
  }
}

#Preview {
  AppView()
}
