//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
  var body: some View {
    TabView {
      Tab("Explore", systemImage: "eyes") {
        NavigationStack {
          ExploreView()
        }
      }
      Tab("Chats", systemImage: "bubble.left.and.bubble.right.fill") {
        NavigationStack {
          ChatsView()
        }
      }
      Tab("Profile", systemImage: "person.fill") {
        NavigationStack {
          ProfileView()
        }
      }
    }
  }
}

#Preview {
  TabBarView()
}
