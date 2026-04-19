//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CustomListCellView: View {
  var imageURL: URL? = Constants.randomImageURL
  var title: String? = "Alpha"
  var subtitle: String? = "An alien that is smiling in the park"

  var body: some View {
    HStack(spacing: 8) {
      ZStack {
        if let imageURL {
          ImageLoaderView(url: imageURL)
        } else {
          Rectangle()
            .fill(.gray.opacity(0.6))
        }
      }
      .aspectRatio(1, contentMode: .fit)
      .frame(height: 60)
      .clipShape(.rect(cornerRadius: 16))

      VStack(alignment: .leading, spacing: 4) {
        if let title {
          Text(title)
            .font(.headline)
        }
        if let subtitle {
          Text(subtitle)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  CustomListCellView()
}

#Preview("No Image") {
  CustomListCellView(imageURL: nil)
}

#Preview("No Title") {
  CustomListCellView(title: nil)
}

#Preview("No Subtitle") {
  CustomListCellView(subtitle: nil)
}

#Preview("Empty") {
  CustomListCellView(imageURL: nil, title: nil, subtitle: nil)
}
