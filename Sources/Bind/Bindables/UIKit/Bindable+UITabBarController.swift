#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UITabBarController {
    var selectedIndex: Binder<Int> {
        return Binder<Int>(self.target) { tabBarController, index in
            tabBarController.selectedIndex = index
        }
    }
}
#endif
