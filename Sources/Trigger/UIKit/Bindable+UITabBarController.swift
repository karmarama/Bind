#if !os(macOS) && !os(watchOS)
import UIKit

extension Bindable where TargetType: UITabBarController {
    var selectedIndex: Binder<Int> {
        return Binder<Int>(self.target) { tabBarController, index in
            tabBarController.selectedIndex = index
        }
    }
}
#endif
