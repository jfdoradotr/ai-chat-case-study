//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Environment(AppState.self) private var appState

  var body: some View {
    List {
      Button(
        "Sign out",
        role: .destructive,
        action: onSignOutPressed
      )
    }
    .navigationTitle("Settings")
  }

  private func onSignOutPressed() {
    appState.updateViewState(showTabBar: false)
  }
}

#Preview {
  NavigationStack {
    SettingsView()
      .environment(AppState())
  }
}
