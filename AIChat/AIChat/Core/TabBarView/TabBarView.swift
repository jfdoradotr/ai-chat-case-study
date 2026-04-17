//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  var body: some View {
    TabView {
      Tab("Explore", systemImage: "eyes") {
        NavigationStack {
          Text("Explore")
        }
      }
      Tab("Chats", systemImage: "bubble.left.and.bubble.right.fill") {
        NavigationStack {
          Text("Chats")
        }
      }
      Tab("Profile", systemImage: "person.fill") {
        NavigationStack {
          Text("Profile")
        }
      }
    }
  }
}

#Preview {
  TabBarView()
}
