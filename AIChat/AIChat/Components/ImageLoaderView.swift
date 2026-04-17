//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
  let url: URL?
  var contentMode: ContentMode = .fill

  var body: some View {
    Color.clear
      .overlay {
        WebImage(url: url)
          .resizable()
          .indicator(.activity)
          .aspectRatio(contentMode: contentMode)
          .allowsHitTesting(false)
      }
      .clipped()
  }
}

#Preview {
  ImageLoaderView(url: Constants.randomImageURL)
    .frame(width: 100, height: 200)
}
