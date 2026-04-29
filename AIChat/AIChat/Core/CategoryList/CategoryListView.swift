//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CategoryListView: View {
  var category: AvatarModel.Character = .alien
  var imageURL: URL? = Constants.randomImageURL
  @State private var avatars: [AvatarModel] = .preview

  var body: some View {
    List {
      CategoryCellView(
        title: category.plural.capitalized,
        imageURL: imageURL,
        font: .largeTitle,
        cornerRadius: 0
      )
      .listRowInsets(EdgeInsets())

      ForEach(avatars) { avatar in
        CustomListCellView(
          imageURL: avatar.imageURL,
          title: avatar.name,
          subtitle: avatar.description
        )
      }
    }
    .listStyle(.plain)
    .ignoresSafeArea(edges: .top)
  }
}

#Preview {
  CategoryListView()
}
