//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
  let featuredAvatars: [AvatarModel] = .preview

  var body: some View {
    List {
      featuredAvatarsSection
        .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
    .navigationTitle("Explore")
  }

  private var featuredAvatarsSection: some View {
    Section {
      CarouselView(items: featuredAvatars) { avatar in
        HeroCellView(
          imageURL: Constants.randomImageURL,
          title: avatar.name,
          subtitle: avatar.description
        )
      }
      .frame(height: 200)
    } header: {
      Text("Featured Avatars")
    }
  }
}

#Preview {
  ExploreView()
}
