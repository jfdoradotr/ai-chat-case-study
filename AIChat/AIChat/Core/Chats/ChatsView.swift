//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
  @State private var chats: [ChatModel] = .preview
  @State private var recentAvatars: [AvatarModel] = .preview

  var body: some View {
    List {
      if !recentAvatars.isEmpty {
        recentsSection
      }
      chatsSection
    }
    .listStyle(.plain)
    .navigationTitle("Chats")
    .navigationDestination(for: String.self) { avatarId in
      ChatView(avatarId: avatarId)
    }
  }

  private var recentsSection: some View {
    Section {
      ScrollView(.horizontal) {
        LazyHStack(spacing: 8) {
          ForEach(recentAvatars) { avatar in
            NavigationLink(value: avatar.avatarId) {
              if let imageURL = avatar.imageURL {
                VStack(spacing: 8) {
                  ImageLoaderView(url: imageURL)
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(.circle)

                  Text(avatar.name ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
              }
            }
          }
        }
      }
      .frame(height: 120)
      .scrollIndicators(.hidden)
    } header: {
      Text("Recents")
    }
    .listRowSeparator(.hidden)
  }

  private var chatsSection: some View {
    Section {
      if chats.isEmpty {
        Text("Your chats will appear here!")
          .foregroundStyle(.secondary)
          .font(.title3)
          .frame(maxWidth: .infinity)
          .multilineTextAlignment(.center)
          .padding(40)
          .listRowSeparator(.hidden)
      } else {
        ForEach(chats) { chat in
          NavigationLink(value: chat.avatarId) {
            ChatRowCellViewBuilder(
              currentUserId: nil, // FIXME: Add current user id
              chat: chat,
              getAvatar: {
                try? await Task.sleep(for: .seconds(1))
                return [AvatarModel].preview.randomElement()
              },
              getLastChatMessage: {
                try? await Task.sleep(for: .seconds(1))
                return [ChatMessageModel].preview.randomElement()
              }
            )
            .listRowSeparator(.hidden)
          }
        }
      }
    } header: {
      Text("Chats")
    }
  }
}

#Preview {
  NavigationStack {
    ChatsView()
  }
}
