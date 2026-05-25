//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CategoryListView: View {
  @Environment(AvatarManager.self) private var avatarManager

  var category: AvatarModel.Character = .alien
  var imageURL: URL? = Constants.randomImageURL

  @State private var avatars: [AvatarModel] = []
  @State private var isLoading = false
  @State private var loadError: String?

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
        stateContent
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
    .trackScreen(ScreenEvent.categoryList)
  }

  @ViewBuilder private var stateContent: some View {
    if isLoading {
      ProgressView()
        .padding(40)
        .controlSize(.large)
        .frame(maxWidth: .infinity)
    } else if let loadError {
      ContentUnavailableView {
        Label("Couldn't load avatars", systemImage: "exclamationmark.triangle.fill")
      } description: {
        Text(loadError)
      } actions: {
        Button {
          Task { await loadAvatars() }
        } label: {
          Text("Try Again")
        }
        .buttonStyle(.borderedProminent)
      }
    } else {
      ContentUnavailableView {
        Label("No \(category.plural.lowercased()) yet", systemImage: "face.dashed")
      } description: {
        Text("Check back later — there's nothing in this category right now.")
      }
    }
  }

  private func loadAvatars() async {
    isLoading = true
    loadError = nil
    do {
      avatars = try await avatarManager.getAvatars(forCategory: category)
    } catch {
      loadError = "Failed to load avatars: \(error.localizedDescription)"
    }
    isLoading = false
  }
}

#Preview("Has Data") {
  NavigationStack {
    CategoryListView()
      .previewEnvironment()
  }
}

#Preview("Loading") {
  NavigationStack {
    CategoryListView()
      .previewEnvironment(avatarRemote: MockAvatarService(delay: 60))
  }
}

#Preview("Empty") {
  NavigationStack {
    CategoryListView()
      .previewEnvironment(avatarRemote: MockAvatarService(avatars: [], delay: 0))
  }
}

#Preview("Error") {
  NavigationStack {
    CategoryListView()
      .previewEnvironment(avatarRemote: MockAvatarService(delay: 0, shouldThrow: true))
  }
}
