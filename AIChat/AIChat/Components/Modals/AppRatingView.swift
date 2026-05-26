//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

/// Concrete "happiness check" modal shown before requesting an App Store review,
/// so we only surface the system review prompt to users who say they're enjoying the app.
struct AppRatingView: View {
  var onYesPressed: () -> Void
  var onNoPressed: () -> Void

  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 8) {
        Text("Are you enjoying AIChat?")
          .font(.title2.weight(.semibold))
        Text("We'd love to hear your feedback!")
          .font(.callout)
          .foregroundStyle(.secondary)
      }

      VStack(spacing: 12) {
        Button(action: onYesPressed) {
          Text("Yes!")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)

        Button(action: onNoPressed) {
          Text("Not really")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderless)
        .controlSize(.large)
      }
    }
    .multilineTextAlignment(.center)
    .padding(24)
    .background(.thinMaterial)
    .clipShape(.rect(cornerRadius: 16))
    .accessibilityAddTraits(.isModal)
  }
}

/// Presentation wrapper for `AppRatingView`: fades the dimmed scrim in/out and
/// scales the card into the center, instead of the default cover slide-up.
/// Designed to be presented inside a `.fullScreenCover` with a cleared background.
struct AppRatingModal: View {
  @Binding var isPresented: Bool
  var onYesPressed: () -> Void
  var onNoPressed: () -> Void

  @State private var isVisible = false

  var body: some View {
    ZStack {
      Color.black.opacity(isVisible ? 0.6 : 0)
        .ignoresSafeArea()
        .onTapGesture { dismiss(then: {}) }

      AppRatingView(
        onYesPressed: { dismiss(then: onYesPressed) },
        onNoPressed: { dismiss(then: onNoPressed) }
      )
      .padding(40)
      .opacity(isVisible ? 1 : 0)
      .scaleEffect(isVisible ? 1 : 0.9)
    }
    .presentationBackground(.clear)
    .onAppear {
      withAnimation(.easeOut(duration: 0.2)) { isVisible = true }
    }
  }

  private func dismiss(then action: @escaping () -> Void) {
    withAnimation(.easeIn(duration: 0.2)) {
      isVisible = false
    } completion: {
      isPresented = false
      action()
    }
  }
}

#Preview {
  AppRatingView(onYesPressed: {}, onNoPressed: {})
    .padding(40)
}
