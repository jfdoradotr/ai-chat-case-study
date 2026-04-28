//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatView: View {
  @State private var chatMesages: [ChatMessageModel] = .preview
  @State private var avatar: AvatarModel? = .preview
  @State private var currentUser: UserModel? = .preview

  var body: some View {
    VStack(spacing: 0) {
      ScrollView {
        LazyVStack(spacing: 24) {
          ForEach(chatMesages) { message in
            let isCurrentUser = message.authorId == currentUser?.userId
            ChatBubbleViewBuilder(
              message: message,
              isCurrentUser: isCurrentUser,
              imageURL: avatar?.imageURL
            )
          }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 8)
      }

      Rectangle()
        .frame(height: 50)
    }
    .navigationTitle(avatar?.name ?? "Chat")
    .toolbarTitleDisplayMode(.inline)
  }
}

#Preview {
  NavigationStack {
    ChatView()
  }
}
