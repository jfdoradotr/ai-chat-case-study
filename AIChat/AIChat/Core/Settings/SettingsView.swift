//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(AppState.self) private var appState

  @State private var isPremium = false

  var body: some View {
    List {
      Section {
        Button(
          "Sign out",
          action: onSignOutPressed
        )
        .foregroundStyle(.primary)
        Button(
          "Delete account",
          role: .destructive,
          action: onSignOutPressed
        )
      } header: {
        Text("Account")
      }
      Section {
        HStack {
          Text("Account status: \(isPremium ? "PREMIUM" : "FREE")")
          Spacer()
          Button("MANAGE") {}
            .font(.caption)
            .bold()
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.blue)
            .clipShape(.capsule)
        }
      } header: {
        Text("Purchases")
      }
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
