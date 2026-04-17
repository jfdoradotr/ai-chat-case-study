//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingColorSelectionView: View {
  @State private var selectedColor: Color?

  private let profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan]

  var body: some View {
    ScrollView {
      LazyVGrid(
        columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
        alignment: .center,
        spacing: 16,
        pinnedViews: [.sectionHeaders],
        content: {
          Section {
            ForEach(profileColors, id: \.self) { color in
              Circle()
                .fill(.accent)
                .overlay {
                  color
                    .clipShape(Circle())
                    .padding(selectedColor == color ? 10 : 0)
                }
                .onTapGesture {
                  selectedColor = color
                }
            }
          } header: {
            Text("Select a profile color")
              .font(.headline)
          }
        }
      )
      .padding(.horizontal, 24)
    }
    .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16) {
      ZStack {
        if let selectedColor {
          NavigationLink {
            OnboardingCompletedView()
          } label: {
            Text("Continue")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.glassProminent)
          .controlSize(.large)
          .transition(AnyTransition.move(edge: .bottom))
        }
      }
      .padding(.horizontal, 24)
      .background(Color(.systemBackground))
    }
    .animation(.bouncy, value: selectedColor)
  }
}

#Preview {
  NavigationStack {
    OnboardingColorSelectionView()
  }
}
