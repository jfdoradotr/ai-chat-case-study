//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @AppStorage("showTabBarView") private var showTabBar = false

  var body: some View {
    AppViewBuilder(
      showTabBar: showTabBar,
      tabBarView: {
        TabBarView()
      },
      onboardingView: {
        NavigationStack {
          WelcomeView()
        }
      }
    )
    .onTapGesture {
      showTabBar.toggle()
    }
  }
}

#Preview {
  AppView()
}
