//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
  @State private var avatar: AvatarModel?
  @State private var lastChatMessage: ChatMessageModel?

  var currentUserId: String? = ""
  var chat: ChatModel = .preview
  var getAvatar: () async -> AvatarModel?
  var getLastChatMessage: () async -> ChatMessageModel?

  var body: some View {
    ChatRowCellView(
      imageURL: avatar?.imageURL,
      headline: avatar?.name,
      subheadline: lastChatMessage?.content,
      hasNewChat: hasNewChat
    )
    .task {
      avatar = await getAvatar()
    }
    .task {
      lastChatMessage = await getLastChatMessage()
    }
  }

  private var hasNewChat: Bool {
    guard let lastChatMessage, let currentUserId else { return false }
    return lastChatMessage.hasBeenSeenByCurrentUser(userId: currentUserId)
  }
}

#Preview {
  ChatRowCellViewBuilder(
    chat: .preview,
    getAvatar: { return .preview },
    getLastChatMessage: { return .preview }
  )
}
