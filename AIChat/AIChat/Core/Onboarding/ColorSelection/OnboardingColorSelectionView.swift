//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct OnboardingColorSelectionView: View {
  @State private var selectedColor: Color?

  private let profileColors: [Color] = [.red, .green, .orange, .blue, .mint, .purple, .cyan, .teal, .indigo]

  var body: some View {
    ScrollView {
      colorGrid
        .padding(.horizontal, 24)
    }
    .safeAreaInset(edge: .bottom, alignment: .center, spacing: 16) {
      bottomBar
    }
    .animation(.bouncy, value: selectedColor)
  }

  private var colorGrid: some View {
    LazyVGrid(
      columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
      alignment: .center,
      spacing: 16,
      pinnedViews: [.sectionHeaders]
    ) {
      Section {
        ForEach(profileColors, id: \.self) { color in
          ProfileColorCell(color: color, isSelected: selectedColor == color) {
            selectedColor = color
          }
        }
      } header: {
        Text("Select a profile color")
          .font(.headline)
      }
    }
  }

  @ViewBuilder private var bottomBar: some View {
    ZStack {
      if let selectedColor {
        PrimaryButton(title: "Continue") {
          OnboardingCompletedView(selectedColor: selectedColor)
        }
        .transition(.move(edge: .bottom))
      }
    }
    .padding(.horizontal, 24)
    .background(Color(.systemBackground))
  }
}

private struct ProfileColorCell: View {
  let color: Color
  let isSelected: Bool
  let onTap: () -> Void

  var body: some View {
    Button(action: onTap) {
      Circle()
        .fill(.accent)
        .overlay {
          color
            .clipShape(Circle())
            .padding(isSelected ? 10 : 0)
        }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  NavigationStack {
    OnboardingColorSelectionView()
  }
}
