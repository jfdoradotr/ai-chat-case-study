//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CreateAvatarView: View {
  var body: some View {
    List {

    }
    .navigationTitle("Create Avatar")
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Close", systemImage: "xmark", role: .close, action: onClosePressed)
      }
    }
  }

  private func onClosePressed() {

  }
}

#Preview {
  NavigationStack {
    CreateAvatarView()
  }
}
