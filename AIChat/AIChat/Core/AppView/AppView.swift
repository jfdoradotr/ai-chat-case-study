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
        ZStack {
          Color.red.ignoresSafeArea()
          Text("TabBar")
        }
      },
      onboardingView: {
        ZStack {
          Color.blue.ignoresSafeArea()
          Text("Onboarding")
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
