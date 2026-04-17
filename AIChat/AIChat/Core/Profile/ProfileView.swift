//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  @State private var showSettingsView = false

  var body: some View {
    Text("Profile")
      .navigationTitle("Profile")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button("Settings", systemImage: "gear") {
            showSettingsView = true
          }
        }
      }
      .sheet(isPresented: $showSettingsView) {
        Text("SettingsView")
      }
  }
}

#Preview {
  NavigationStack {
    ProfileView()
  }
}
