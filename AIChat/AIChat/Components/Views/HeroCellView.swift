//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct HeroCellView: View {
  var imageURL: URL? = Constants.randomImageURL
  var title: String? = "This is some title"
  var subtitle: String? = "This is some subtitle that will go here"

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
        if let subtitle {
          Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.white)
        }
      }
      .padding(16)
    }
    .clipShape(.rect(cornerRadius: 32))
  }
}

#Preview {
  HeroCellView()
    .frame(height: 200)
}

#Preview("No Subtitle") {
  HeroCellView(subtitle: nil)
    .frame(height: 200)
}

#Preview("No Title") {
  HeroCellView(title: nil)
    .frame(height: 200)
}

#Preview("No Image") {
  HeroCellView(imageURL: nil)
    .frame(height: 200)
}
