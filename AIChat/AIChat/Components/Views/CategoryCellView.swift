//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CategoryCellView: View {
  var title: String? = "Alien"
  var imageURL: URL? = Constants.randomImageURL
  var font: Font = .title2
  var cornerRadius: CGFloat = 12

  var body: some View {
    ZStack {
      if let imageURL {
        ImageLoaderView(url: imageURL)
      } else {
        Rectangle()
          .fill(.gray.opacity(0.6))
      }
    }
    .overlay(
      LinearGradient(
        colors: [
          .black.opacity(0),
          .black.opacity(0.3),
          .black.opacity(0.6)
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    )
    .overlay(alignment: .bottomLeading) {
      VStack(alignment: .leading, spacing: 4) {
        if let title {
          Text(title)
            .font(.headline)
            .foregroundStyle(.white)
        }
      }
      .padding(24)
    }
    .clipShape(.rect(cornerRadius: cornerRadius))
    .aspectRatio(1, contentMode: .fit)
  }
}

#Preview {
  CategoryCellView()
}
