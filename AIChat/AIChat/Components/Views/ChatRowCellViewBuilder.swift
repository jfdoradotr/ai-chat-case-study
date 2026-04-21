//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
  @State private var avatar: AvatarModel?
  @State private var lastChatMessage: ChatMessageModel?
  @State private var didLoadAvatar = false
  @State private var didLoadChatMessage = false

  var currentUserId: String? = ""
  var chat: ChatModel = .preview
  var getAvatar: () async -> AvatarModel?
  var getLastChatMessage: () async -> ChatMessageModel?

  private var isLoading: Bool {
    if didLoadAvatar && didLoadChatMessage {
      return false
    }
    return true
  }

  private var subheadline: String? {
    if isLoading {
      return "xxxx xxxx xxxx xxxx"
    }

    if avatar == nil && lastChatMessage == nil {
      return "Error loading data"
    }

    return  lastChatMessage?.content
  }

  var body: some View {
    ChatRowCellView(
      imageURL: avatar?.imageURL,
      headline: isLoading ? "xxxx xxxx" : avatar?.name,
      subheadline: subheadline,
      hasNewChat: isLoading ? false : hasNewChat
    )
    .redacted(reason: isLoading ? .placeholder : [])
    .task {
      avatar = await getAvatar()
      didLoadAvatar = true
    }
    .task {
      lastChatMessage = await getLastChatMessage()
      didLoadChatMessage = true
    }
  }

  private var hasNewChat: Bool {
    guard let lastChatMessage, let currentUserId else { return false }
    return lastChatMessage.hasBeenSeenByCurrentUser(userId: currentUserId)
  }
}

#Preview {
  List {
    ChatRowCellViewBuilder(
      chat: .preview,
      getAvatar: {
        try? await Task.sleep(for: .seconds(5))
        return .preview
      },
      getLastChatMessage: {
        try? await Task.sleep(for: .seconds(5))
        return .preview
      }
    )
    ChatRowCellViewBuilder(
      chat: .preview,
      getAvatar: { return .preview },
      getLastChatMessage: { return .preview }
    )
    ChatRowCellViewBuilder(
      chat: .preview,
      getAvatar: { return nil },
      getLastChatMessage: { return nil }
    )
  }
}
