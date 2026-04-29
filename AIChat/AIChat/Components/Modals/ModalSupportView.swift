//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

struct ModalSupportViewModifier<ModalContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  @ViewBuilder var modalContent: ModalContent

  func body(content: Content) -> some View {
    content
      .overlay {
        ZStack {
          if isPresented {
            Color.black.opacity(0.6)
              .ignoresSafeArea()
              .transition(AnyTransition.opacity.animation(.smooth))
              .onTapGesture {
                isPresented = false
              }
            modalContent
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        .zIndex(9999)
        .animation(.bouncy, value: isPresented)
      }
  }
}

extension View {
  func showModal<Content: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder content: () -> Content
  ) -> some View {
    modifier(
      ModalSupportViewModifier(
        isPresented: isPresented,
        modalContent: content
      )
    )
  }
}

#Preview {
  @Previewable @State var showModal = false

  Button("Click me") { showModal = true }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .showModal(isPresented: $showModal) {
      Text("Hi")
        .background(Color.red)
        .transition(.slide)
    }
}
