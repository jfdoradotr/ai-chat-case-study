//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
  @Environment(AvatarManager.self) private var avatarManager

  @State private var featuredAvatars: [AvatarModel] = []
  @State private var popularAvatars: [AvatarModel] = []
  @State private var isLoading = false
  @State private var loadError: String?

  let categories: [AvatarModel.Character] = AvatarModel.Character.allCases

  var body: some View {
    List {
      if isLoading && featuredAvatars.isEmpty && popularAvatars.isEmpty {
        ProgressView()
          .padding(40)
          .controlSize(.large)
          .frame(maxWidth: .infinity)
          .listRowSeparator(.hidden)
      } else if let loadError, featuredAvatars.isEmpty && popularAvatars.isEmpty {
        errorView(message: loadError)
          .listRowSeparator(.hidden)
      }

      if !featuredAvatars.isEmpty {
        featuredAvatarsSection
          .listRowSeparator(.hidden)
      }

      if !popularAvatars.isEmpty {
        categoriesSection
          .listRowSeparator(.hidden)
        popularSection
      }
    }
    .listStyle(.plain)
    .navigationTitle("Explore")
    .task {
      await loadAll()
    }
    .navigationDestination(for: String.self) { value in
      ChatView(avatarId: value)
    }
    .navigationDestination(for: AvatarModel.Character.self) { category in
      CategoryListView(category: category, imageURL: Constants.randomImageURL)
    }
  }

  private func loadAll() async {
    isLoading = true
    loadError = nil
    async let featured: () = loadFeaturedAvatars()
    async let popular: () = loadPopularAvatars()
    _ = await (featured, popular)
    isLoading = false
  }

  private func loadFeaturedAvatars() async {
    do {
      featuredAvatars = try await avatarManager.getFeaturedAvatars()
    } catch {
      loadError = "Couldn't load avatars: \(error.localizedDescription)"
    }
  }

  private func loadPopularAvatars() async {
    do {
      popularAvatars = try await avatarManager.getPopularAvatars()
    } catch {
      loadError = "Couldn't load avatars: \(error.localizedDescription)"
    }
  }

  private func errorView(message: String) -> some View {
    ContentUnavailableView {
      Label("Something went wrong", systemImage: "exclamationmark.triangle.fill")
    } description: {
      Text(message)
    } actions: {
      Button {
        Task { await loadAll() }
      } label: {
        Text("Try Again")
      }
      .buttonStyle(.borderedProminent)
    }
    .frame(maxWidth: .infinity)
  }

  private var featuredAvatarsSection: some View {
    Section {
      CarouselView(items: featuredAvatars) { avatar in
        NavigationLink(value: avatar.avatarId) {
          HeroCellView(
            imageURL: avatar.imageURL,
            title: avatar.name,
            subtitle: avatar.description
          )
        }
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
            if let imageURL = popularAvatars.first(where: { $0.character == category })?.imageURL {
              NavigationLink(value: category) {
                CategoryCellView(
                  title: category.plural.capitalized,
                  imageURL: imageURL
                )
                .frame(height: 140)
              }
            }
          }
        }
      }
      .scrollIndicators(.hidden)
    } header: {
      Text("Categories")
    }
  }

  private var popularSection: some View {
    Section {
      ForEach(popularAvatars) { avatar in
        NavigationLink(value: avatar.avatarId) {
          CustomListCellView(
            imageURL: avatar.imageURL,
            title: avatar.name,
            subtitle: avatar.description
          )
        }
      }
    } header: {
      Text("Popular")
    }
  }
}

#Preview("Has Data") {
  NavigationStack {
    ExploreView()
      .environment(AvatarManager(services: MockAvatarServices()))
  }
}

#Preview("Loading") {
  NavigationStack {
    ExploreView()
      .environment(
        AvatarManager(services: MockAvatarServices(remote: MockAvatarService(delay: 60)))
      )
  }
}

#Preview("Empty") {
  NavigationStack {
    ExploreView()
      .environment(
        AvatarManager(services: MockAvatarServices(remote: MockAvatarService(avatars: [], delay: 0)))
      )
  }
}

#Preview("Error") {
  NavigationStack {
    ExploreView()
      .environment(
        AvatarManager(services: MockAvatarServices(remote: MockAvatarService(delay: 0, shouldThrow: true)))
      )
  }
}
