//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ChatRowCellView: View {
  var imageURL: URL? = Constants.randomImageURL
  var headline: String? = "Alpha"
  var subheadline: String? = "This is the last message in the chat."
  var hasNewChat: Bool = true

  var body: some View {
    HStack {
      ZStack {
        if let imageURL {
          ImageLoaderView(url: imageURL)
        } else {
          Rectangle()
            .fill(Color.gray)
        }
      }
      .frame(width: 50, height: 50)
      .aspectRatio(1, contentMode: .fill)
      .clipShape(Circle())

      VStack(alignment: .leading, spacing: 4) {
        if let headline {
          Text(headline)
            .font(.headline)
        }

        if let subheadline {
          Text(subheadline)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if hasNewChat {
        Text("NEW")
          .font(.caption)
          .bold()
          .foregroundStyle(.white)
          .padding(.horizontal, 8)
          .padding(.vertical, 6)
          .background(Color.blue)
          .clipShape(.capsule)
      }
    }
  }
}

#Preview {
  List {
    ChatRowCellView()
    ChatRowCellView(hasNewChat: false)
    ChatRowCellView(imageURL: nil)
    ChatRowCellView(headline: nil)
    ChatRowCellView(subheadline: nil)
    ChatRowCellView(imageURL: nil, headline: nil, subheadline: nil)
    ChatRowCellView(imageURL: nil, headline: nil, subheadline: nil, hasNewChat: false)
  }
}
