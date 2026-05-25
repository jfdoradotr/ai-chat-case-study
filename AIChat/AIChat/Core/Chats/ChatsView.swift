//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
  @Environment(AvatarManager.self) private var avatarManager
  @Environment(ChatManager.self) private var chatManager
  @Environment(UserManager.self) private var userManager
  @Environment(LogManager.self) private var logManager

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
      await loadRecentAvatars()
    }
    .task(id: userManager.currentUser?.userId) {
      await listenToChats()
    }
    .trackScreen(ScreenEvent.chats)
  }

  private func loadRecentAvatars() async {
    logManager.trackEvent(event: ChatsEvent.loadRecentAvatarsStart)
    do {
      let loaded = try await avatarManager.getRecentAvatars()
      recentAvatars = loaded
      logManager.trackEvent(event: ChatsEvent.loadRecentAvatarsSuccess(count: loaded.count))
    } catch {
      logManager.trackEvent(event: ChatsEvent.loadRecentAvatarsFailure(error: error))
    }
  }

  private func listenToChats() async {
    guard let userId = userManager.currentUser?.userId else { return }
    logManager.trackEvent(event: ChatsEvent.listenChatsStart)
    do {
      for try await updated in chatManager.streamAllChats(userId: userId) {
        chats = updated
        logManager.trackEvent(event: ChatsEvent.listenChatsSuccess(count: updated.count))
      }
    } catch {
      logManager.trackEvent(event: ChatsEvent.listenChatsFailure(error: error))
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
            .simultaneousGesture(TapGesture().onEnded {
              logManager.trackEvent(event: ChatsEvent.recentAvatarPressed(avatarId: avatar.avatarId))
            })
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
              chat: chat,
              getAvatar: {
                try? await avatarManager.getAvatar(id: chat.avatarId)
              },
              getLastChatMessage: {
                try? await chatManager.getLastMessage(forChatId: chat.id)
              }
            )
            .listRowSeparator(.hidden)
          }
          .simultaneousGesture(TapGesture().onEnded {
            logManager.trackEvent(event: ChatsEvent.chatRowPressed(chat: chat))
          })
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
