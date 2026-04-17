//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  var body: some View {
    TabView {
      Tab("Explore", systemImage: "eyes") {
        Text("Explore")
      }
      Tab("Chats", systemImage: "bubble.left.and.bubble.right.fill") {
        Text("Chats")
      }
      Tab("Profile", systemImage: "person.fill") {
        Text("Profile")
      }
    }
  }
}

#Preview {
  TabBarView()
}
