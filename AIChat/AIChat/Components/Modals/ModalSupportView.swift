//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ModalSupportView<Content: View>: View {
  @Binding var showModal: Bool
  @ViewBuilder var content: Content

  var body: some View {
    ZStack {
      if showModal {
        Color.black.opacity(0.6)
          .ignoresSafeArea()
          .transition(AnyTransition.opacity.animation(.smooth))
          .onTapGesture {
            showModal = false
          }
        content
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .zIndex(9999)
    .animation(.bouncy, value: showModal)
  }
}

#Preview {
  @Previewable @State var showModal = false

  ZStack {
    Button("Click me") { showModal = true }
    ModalSupportView(showModal: $showModal) {
      Text("Hi")
        .background(Color.red)
        .transition(.slide)
    }
  }
}
