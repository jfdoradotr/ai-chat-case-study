//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CategoryListView: View {
  @Environment(AvatarManager.self) private var avatarManager

  var category: AvatarModel.Character = .alien
  var imageURL: URL? = Constants.randomImageURL

  @State private var avatars: [AvatarModel] = []
  @State private var errorMessage: String?

  var body: some View {
    List {
      CategoryCellView(
        title: category.plural.capitalized,
        imageURL: imageURL,
        font: .largeTitle,
        cornerRadius: 0
      )
      .listRowInsets(EdgeInsets())

      if avatars.isEmpty {
        ProgressView()
          .padding(40)
          .controlSize(.large)
          .frame(maxWidth: .infinity)
          .listRowSeparator(.hidden)
      } else {
        ForEach(avatars) { avatar in
          NavigationLink(value: avatar.id) {
            CustomListCellView(
              imageURL: avatar.imageURL,
              title: avatar.name,
              subtitle: avatar.description
            )
          }
        }
      }
    }
    .navigationDestination(for: String.self) { avatarId in
      ChatView(avatarId: avatarId)
    }
    .listStyle(.plain)
    .ignoresSafeArea(edges: .top)
    .task {
      await loadAvatars()
    }
    .alert(
      "Something went wrong",
      isPresented: Binding(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      ),
      presenting: errorMessage
    ) { _ in
      Button("OK", role: .cancel) {}
    } message: { message in
      Text(message)
    }
  }

  private func loadAvatars() async {
    do {
      avatars = try await avatarManager.getAvatars(forCategory: category)
    } catch {
      errorMessage = "Failed to load avatars: \(error.localizedDescription)"
    }
  }
}

#Preview {
  CategoryListView()
    .environment(AvatarManager(services: MockAvatarServices()))
}
