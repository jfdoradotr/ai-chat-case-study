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
      ImageLoaderView(url: imageURL)
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
  }
}

#Preview {
  HeroCellView()
    .frame(height: 200)
}
