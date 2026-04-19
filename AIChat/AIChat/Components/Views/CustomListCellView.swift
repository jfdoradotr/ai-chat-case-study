//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CustomListCellView: View {
  var imageURL: URL? = Constants.randomImageURL

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
        Text("Alpha")
          .font(.headline)
        Text("An alien that is smiling in the park")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  CustomListCellView()
}
