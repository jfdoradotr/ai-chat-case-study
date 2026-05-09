//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import SwiftUI

extension View {
  func trackScreen(_ event: any LoggableEvent) -> some View {
    modifier(TrackScreenModifier(event: event))
  }
}

private struct TrackScreenModifier: ViewModifier {
  @Environment(LogManager.self) private var logManager
  let event: any LoggableEvent

  func body(content: Content) -> some View {
    content.onAppear {
      logManager.trackScreenEvent(event: event)
    }
  }
}
