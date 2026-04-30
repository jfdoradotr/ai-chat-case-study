//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct AppView: View {
  @Environment(\.authService) private var authService
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
    .task {
      await checkUserStatus()
    }
  }

  private func checkUserStatus() async {
    if let user = authService.getAuthenticatedUser() {
      // user authenticated
    } else {
      // user is not authenticated
      do {
        let result = try await authService.signInAnonymously()
      } catch {
        
      }
    }
  }
}

#Preview {
  AppView()
}
