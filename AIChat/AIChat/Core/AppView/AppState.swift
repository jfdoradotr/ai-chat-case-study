//
//  Copyright © Juan Francisco Dorado Torres. All rights reserved.
//

import Foundation
import Observation

@Observable
final class AppState {
  private(set) var showTabBar: Bool {
    didSet { UserDefaults.showTabBarView = showTabBar }
  }

  init(showTabBar: Bool = UserDefaults.showTabBarView) {
    self.showTabBar = showTabBar
  }

  func updateViewState(showTabBar: Bool) {
    self.showTabBar = showTabBar
  }
}

private extension UserDefaults {
  private struct Keys {
    static let showTabBarView = "showTabBarView"
  }

  static var showTabBarView: Bool {
    get { standard.bool(forKey: Keys.showTabBarView) }
    set { standard.set(newValue, forKey: Keys.showTabBarView) }
  }
}
