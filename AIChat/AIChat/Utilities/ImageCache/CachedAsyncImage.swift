//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
  let url: URL?
  private let cache: any ImageCache
  @ViewBuilder private let content: (Image) -> Content
  @ViewBuilder private let placeholder: () -> Placeholder

  @State private var loadedImage: UIImage?

  init(
    url: URL?,
    cache: any ImageCache = ImageCacheStore.shared,
    @ViewBuilder content: @escaping (Image) -> Content,
    @ViewBuilder placeholder: @escaping () -> Placeholder
  ) {
    self.url = url
    self.cache = cache
    self.content = content
    self.placeholder = placeholder
  }

  var body: some View {
    Group {
      if let loadedImage {
        content(Image(uiImage: loadedImage))
      } else {
        placeholder()
      }
    }
    .task(id: url) {
      await load()
    }
  }

  private func load() async {
    loadedImage = nil
    guard let url else { return }

    if let cached = await cache.image(for: url) {
      loadedImage = cached
      return
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoded = await Task.detached(priority: .userInitiated) {
        UIImage(data: data)
      }.value
      guard !Task.isCancelled, let decoded else { return }
      Task { await cache.store(decoded, for: url) }
      loadedImage = decoded
    } catch {
      // Placeholder stays
    }
  }
}

#Preview("Remote URL") {
  CachedAsyncImage(
    url: URL(string: "https://picsum.photos/400")
  ) { image in
    image.resizable().scaledToFill()
  } placeholder: {
    Rectangle().fill(.accent.opacity(0.3))
  }
  .frame(width: 200, height: 200)
  .clipShape(.rect(cornerRadius: 16))
}

#Preview("No URL") {
  CachedAsyncImage(
    url: nil
  ) { image in
    image.resizable().scaledToFill()
  } placeholder: {
    Rectangle().fill(.accent.opacity(0.3))
  }
  .frame(width: 200, height: 200)
  .clipShape(.rect(cornerRadius: 16))
}
