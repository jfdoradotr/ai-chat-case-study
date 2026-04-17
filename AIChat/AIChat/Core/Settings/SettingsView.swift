//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
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
    dismiss()
    Task {
      try? await Task.sleep(for: .seconds(0.3))
    }
    appState.updateViewState(showTabBar: false)
  }
}

#Preview {
  NavigationStack {
    SettingsView()
      .environment(AppState())
  }
}
