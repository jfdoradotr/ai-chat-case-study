//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
  let chats: [ChatModel] = .preview

  var body: some View {
    List {
      ForEach(chats) { chat in
        NavigationLink(value: chat.avatarId) {
          ChatRowCellViewBuilder(
            currentUserId: nil, // FIXME: Add current user id
            chat: chat,
            getAvatar: {
              try? await Task.sleep(for: .seconds(1))
              return .preview
            },
            getLastChatMessage: {
              try? await Task.sleep(for: .seconds(1))
              return .preview
            }
          )
          .listRowSeparator(.hidden)
        }
      }
    }
    .listStyle(.plain)
    .navigationTitle("Chats")
    .navigationDestination(for: String.self) { avatarId in
      ChatView(avatarId: avatarId)
    }
  }
}

#Preview {
  NavigationStack {
    ChatsView()
  }
}
