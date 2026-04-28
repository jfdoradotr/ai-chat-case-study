//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatBubbleViewBuilder: View {
  var message: ChatMessageModel = .preview
  var isCurrentUser = false
  var imageURL: URL?

  var body: some View {
    ChatBubbleView(
      text: message.content ?? "",
      textColor: isCurrentUser ? .white : .primary,
      backgroundColor: isCurrentUser ? .accent : Color(uiColor: .systemGray6),
      showImage: !isCurrentUser,
      imageURL: imageURL
    )
    .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
    .padding(.leading, isCurrentUser ? 75 : 0)
    .padding(.trailing, isCurrentUser ? 0 : 75)
  }
}

#Preview {
  ScrollView {
    VStack(spacing: 24) {
      ChatBubbleViewBuilder()
      ChatBubbleViewBuilder(isCurrentUser: true)
      ChatBubbleViewBuilder()
    }
    .padding(.horizontal, 12)
  }
}
