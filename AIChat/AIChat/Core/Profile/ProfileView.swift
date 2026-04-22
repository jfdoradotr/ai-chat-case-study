//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @State private var showSettingsView = false
  @State private var currentUser: UserModel? = .preview

  var body: some View {
    List {
      Section {
        ZStack {
          Circle()
            .fill(currentUser?.profileColor ?? .accent)
        }
        .frame(width: 100, height: 100)
        .frame(maxWidth: .infinity)
      }
      .listRowInsets(EdgeInsets())
      .listRowBackground(Color.clear)
    }
    .navigationTitle("Profile")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(
          "Settings",
          systemImage: "gear",
          action: onSettingsButtonPressed
        )
      }
    }
    .sheet(isPresented: $showSettingsView) {
      NavigationStack {
        SettingsView()
      }
    }
  }

  private func onSettingsButtonPressed() {
    showSettingsView = true
  }
}

#Preview {
  NavigationStack {
    ProfileView()
      .environment(AppState())
  }
}
