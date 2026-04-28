//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatBubbleView: View {
  var text: String = "This is sample text"
  var textColor: Color = .primary
  var backgroundColor: Color = .gray
  var showImage: Bool = true
  var imageURL: URL?

  private let offset: CGFloat = 14

  var body: some View {
    HStack(alignment: .top) {
      if showImage {
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
        .offset(y: offset)
      }
      Text(text)
        .font(.body)
        .foregroundStyle(textColor)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 16))
    }
    .padding(.bottom, showImage ? offset : 0)
  }
}

#Preview {
  ScrollView {
    VStack(spacing: 16) {
      ChatBubbleView()
      ChatBubbleView()
      ChatBubbleView()
      ChatBubbleView(textColor: .white, backgroundColor: .red, showImage: false)
      ChatBubbleView(textColor: .white, backgroundColor: .red, showImage: false)
    }
  }
}
