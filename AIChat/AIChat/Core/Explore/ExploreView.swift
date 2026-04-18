//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
  let avatar: AvatarModel = .preview

  var body: some View {
    HeroCellView(
      imageURL: Constants.randomImageURL,
      title: avatar.name,
      subtitle: avatar.description
    )
    .frame(height: 200)
    .navigationTitle("Explore")
  }
}

#Preview {
  ExploreView()
}
