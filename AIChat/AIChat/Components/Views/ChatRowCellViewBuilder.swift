//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatRowCellViewBuilder: View {
  @State private var avatar: AvatarModel?
  @State private var lastChatMessage: ChatMessageModel?

  var chat: ChatModel = .preview
  var getAvatar: () async -> AvatarModel
  var getLastChatMessage: () async -> ChatMessageModel

  var body: some View {
    ChatRowCellView(
      imageURL: avatar?.imageURL,
      headline: avatar?.name,
      subheadline: lastChatMessage?.content,
      hasNewChat: false
    )
    .task {
      avatar = await getAvatar()
    }
    .task {
      lastChatMessage = await getLastChatMessage()
    }
  }
}

#Preview {
  ChatRowCellViewBuilder(
    chat: .preview,
    getAvatar: { return .preview },
    getLastChatMessage: { return .preview }
  )
}
