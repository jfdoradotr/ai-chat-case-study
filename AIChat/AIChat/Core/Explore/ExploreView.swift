//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ExploreView: View {
  @Environment(AvatarManager.self) private var avatarManager

  @State private var featuredAvatars: [AvatarModel] = []
  @State private var popularAvatars: [AvatarModel] = []
  @State private var errorMessage: String?

  let categories: [AvatarModel.Character] = AvatarModel.Character.allCases

  var body: some View {
    List {
      if featuredAvatars.isEmpty && popularAvatars.isEmpty {
        ProgressView()
          .padding(40)
          .controlSize(.large)
          .frame(maxWidth: .infinity)
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
      async let featured: () = loadFeaturedAvatars()
      async let popular: () = loadPopularAvatars()
      _ = await (featured, popular)
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
    .navigationDestination(for: String.self) { value in
      ChatView(avatarId: value)
    }
    .navigationDestination(for: AvatarModel.Character.self) { category in
      CategoryListView(category: category, imageURL: Constants.randomImageURL)
    }
  }

  private func loadFeaturedAvatars() async {
    do {
      featuredAvatars = try await avatarManager.getFeaturedAvatars()
    } catch {
      errorMessage = "Failed to load featured avatars: \(error.localizedDescription)"
    }
  }

  private func loadPopularAvatars() async {
    do {
      popularAvatars = try await avatarManager.getPopularAvatars()
    } catch {
      errorMessage = "Failed to load popular avatars: \(error.localizedDescription)"
    }
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

#Preview {
  NavigationStack {
    ExploreView()
      .environment(AvatarManager(services: MockAvatarServices()))
  }
}
