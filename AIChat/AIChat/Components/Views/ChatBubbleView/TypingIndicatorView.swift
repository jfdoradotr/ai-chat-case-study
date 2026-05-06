//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct TypingIndicatorView: View {
  var imageURL: URL?

  private let imageOffset: CGFloat = 14

  var body: some View {
    HStack(alignment: .top) {
      ZStack {
        if let imageURL {
          ImageLoaderView(url: imageURL)
        } else {
          Rectangle()
            .fill(.secondary)
        }
      }
      .frame(width: 45, height: 45)
      .clipShape(.circle)
      .offset(y: imageOffset)

      HStack(spacing: 5) {
        ForEach(0..<3, id: \.self) { index in
          Dot(delay: Double(index) * 0.2)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .background(Color(uiColor: .systemGray6))
      .clipShape(.rect(cornerRadius: 16))
    }
    .padding(.bottom, imageOffset)
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.trailing, 75)
  }

  private struct Dot: View {
    let delay: Double
    @State private var animating = false

    var body: some View {
      Circle()
        .frame(width: 7, height: 7)
        .foregroundStyle(.secondary)
        .opacity(animating ? 1.0 : 0.3)
        .animation(
          .easeInOut(duration: 0.6)
            .repeatForever(autoreverses: true)
            .delay(delay),
          value: animating
        )
        .onAppear { animating = true }
    }
  }
}

#Preview {
  VStack(spacing: 24) {
    TypingIndicatorView()
    TypingIndicatorView(imageURL: Constants.randomImageURL)
  }
  .padding(.horizontal, 12)
}
