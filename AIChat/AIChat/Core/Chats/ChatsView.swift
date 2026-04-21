//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
  let chats: [ChatModel] = .preview

  var body: some View {
    List {
      ForEach(chats) { chat in
        Text(chat.id)
      }
    }
    .listStyle(.plain)
    .navigationTitle("Chats")
  }
}

#Preview {
  NavigationStack {
    ExploreView()
  }
}
