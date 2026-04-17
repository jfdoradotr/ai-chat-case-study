//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @State private var showTabBar = false

  var body: some View {
    ZStack {
      if showTabBar {
        ZStack {
          Color.red.ignoresSafeArea()
          Text("TabBar")
        }
      } else {
        ZStack {
          Color.blue.ignoresSafeArea()
          Text("Onboarding")
        }
      }
    }
    .animation(.smooth, value: showTabBar)
    .onTapGesture {
      showTabBar.toggle()
    }
  }
}

#Preview {
  AppView()
}
