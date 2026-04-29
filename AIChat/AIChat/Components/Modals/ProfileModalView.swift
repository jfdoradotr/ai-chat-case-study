//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ProfileModalView: View {
  var imageURL: URL? = Constants.randomImageURL
  var title: String? = "Alpha"
  var subtitle: String? = "Alien"
  var headline: String? = "An alien in the park."
  var onClosePressed: (() -> Void)

  var body: some View {
    VStack(spacing: 0) {
      if let imageURL {
        ImageLoaderView(url: imageURL)
          .aspectRatio(1, contentMode: .fit)
      }

      VStack(alignment: .leading, spacing: 16) {
        if let title {
          Text(title)
            .font(.title.weight(.semibold))
        }

        if let subtitle {
          Text(subtitle)
            .font(.title3)
            .foregroundStyle(.secondary)
        }

        if let headline {
          Text(headline)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
      .padding(24)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(.thinMaterial)
    .clipShape(.rect(cornerRadius: 16))
    .overlay(
      Button(
        "Close",
        systemImage: "xmark.circle.fill",
        action: onClosePressed
      )
      .labelStyle(.iconOnly)
      .font(.title)
      .foregroundStyle(.black)
      .padding(4)
      .padding(8),
      alignment: .topTrailing
    )
  }
}

#Preview("Modal with Image") {
  ProfileModalView {}
}

#Preview("Modal No Image") {
  ProfileModalView(imageURL: nil) {}
}
