//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
  @Environment(AvatarManager.self) private var avatarManager
  @Environment(ChatManager.self) private var chatManager
  @Environment(UserManager.self) private var userManager

  @State private var chats: [ChatModel] = []
  @State private var recentAvatars: [AvatarModel] = []

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
    .task {
      async let recents: () = loadRecentAvatars()
      async let chatsTask: () = loadChats()
      _ = await (recents, chatsTask)
    }
  }

  private func loadRecentAvatars() async {
    do {
      recentAvatars = try await avatarManager.getRecentAvatars()
    } catch {
      print("Failed to load recent avatars: \(error)")
    }
  }

  private func loadChats() async {
    guard let userId = userManager.currentUser?.userId else { return }
    do {
      chats = try await chatManager.getAllChats(userId: userId)
    } catch {
      print("Failed to load chats: \(error)")
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
              currentUserId: userManager.currentUser?.userId,
              chat: chat,
              getAvatar: {
                try? await avatarManager.getAvatar(id: chat.avatarId)
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
      .previewEnvironment()
  }
}
