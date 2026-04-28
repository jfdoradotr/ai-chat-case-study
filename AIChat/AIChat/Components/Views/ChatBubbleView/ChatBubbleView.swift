//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatBubbleView: View {
  let text: String = "This is sample text"
  var textColor: Color = .primary
  var backgroundColor: Color = .gray
  var imageURL: URL?

  var body: some View {
    HStack(alignment: .top) {
      ZStack {
        if let imageURL {
          ImageLoaderView(url: imageURL)
        } else {
          Rectangle()
            .fill(.secondary)
        }
      }
      .frame(width: 45, height: 45)
      .clipShape(.circle)
      Text(text)
        .font(.body)
        .foregroundStyle(textColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 16))
    }
  }
}

#Preview {
  ScrollView {
    VStack(spacing: 16) {
      ChatBubbleView()
      ChatBubbleView()
      ChatBubbleView()
    }
  }
}
