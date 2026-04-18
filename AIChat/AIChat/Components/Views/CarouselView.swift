//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CarouselView<Content: View, T: Identifiable>: View {
  let items: [T]
  let content: (T) -> Content

  var body: some View {
    TabView {
      ForEach(items) { item in
        content(item)
          .padding(.horizontal, 16)
          .padding(.bottom, 50)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
    .indexViewStyle(.page(backgroundDisplayMode: .always))
  }
}

#Preview {
  CarouselView(items: [AvatarModel].preview) { avatar in
    HeroCellView(
      imageURL: Constants.randomImageURL,
      title: avatar.name,
      subtitle: avatar.description
    )
  }
    .frame(height: 300)
}
