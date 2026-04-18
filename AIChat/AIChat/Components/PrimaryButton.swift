//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct PrimaryButton<Destination: View>: View {
  enum Mode {
    case action(isLoading: Bool, perform: () -> Void)
    case navigation(destination: () -> Destination)
  }

  let title: String
  let mode: Mode

  init(
    title: String,
    isLoading: Bool = false,
    action: @escaping () -> Void
  ) where Destination == EmptyView {
    self.title = title
    self.mode = .action(isLoading: isLoading, perform: action)
  }

  init(
    title: String,
    @ViewBuilder destination: @escaping () -> Destination
  ) {
    self.title = title
    self.mode = .navigation(destination: destination)
  }

  var body: some View {
    content
      .buttonStyle(.glassProminent)
      .controlSize(.large)
  }

  @ViewBuilder private var content: some View {
    switch mode {
    case let .action(isLoading, perform):
      Button(action: perform) {
        label(isLoading: isLoading)
      }
      .disabled(isLoading)

    case let .navigation(destination):
      NavigationLink(destination: destination) {
        label(isLoading: false)
      }
    }
  }

  private func label(isLoading: Bool) -> some View {
    Text(title)
      .frame(maxWidth: .infinity)
      .opacity(isLoading ? 0 : 1)
      .overlay {
        if isLoading {
          ProgressView()
            .tint(.white)
        }
      }
  }
}

#Preview("Action") {
  VStack(spacing: 16) {
    PrimaryButton(title: "Finish") {}
    PrimaryButton(title: "Saving…", isLoading: true) {}
  }
  .padding()
}

#Preview("Navigation") {
  NavigationStack {
    PrimaryButton(title: "Continue") {
      Text("Next screen")
    }
    .padding()
  }
}
