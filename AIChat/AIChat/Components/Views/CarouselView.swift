//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CarouselView<Content: View, T: Identifiable>: View {
  let items: [T]
  @ViewBuilder let content: (T) -> Content

  @State private var selection: T.ID?

  var body: some View {
    VStack(spacing: 16) {
      ScrollView(.horizontal) {
        LazyHStack(spacing: 0) {
          ForEach(items) { item in
            content(item)
              .padding(.horizontal, 16)
              .containerRelativeFrame(.horizontal)
              .scrollTransition(.interactive.threshold(.visible(0.95))) { content, phase in
                content.scaleEffect(phase.isIdentity ? 1 : 0.9)
              }
          }
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.paging)
      .scrollIndicators(.hidden)
      .scrollPosition(id: $selection)

      HStack(spacing: 8) {
        ForEach(items) { item in
          Circle()
            .fill(selection == item.id ? Color.accentColor : Color.secondary.opacity(0.3))
            .frame(width: 8, height: 8)
        }
      }
    }
    .onAppear { selection = items.first?.id }
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
