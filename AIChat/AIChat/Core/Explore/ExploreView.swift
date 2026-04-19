//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
  let featuredAvatars: [AvatarModel] = .preview
  let categories: [AvatarModel.Character] = AvatarModel.Character.allCases

  var body: some View {
    List {
      featuredAvatarsSection
        .listRowSeparator(.hidden)

      categoriesSection
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

  private var categoriesSection: some View {
    Section {
      ScrollView(.horizontal) {
        LazyHStack(spacing: 12) {
          ForEach(categories, id: \.self) { category in
            CategoryCellView(
              title: category.rawValue.capitalized,
              imageURL: Constants.randomImageURL
            )
            .frame(height: 140)
          }
        }
      }
      .scrollIndicators(.hidden)
    } header: {
      Text("Categories")
    }
  }
}

#Preview {
  ExploreView()
}
