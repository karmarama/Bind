#if !os(macOS)
import UIKit

extension Bindable where TargetType: UITabBarController {
    var selectedIndex: Binder<Int> {
        return Binder<Int>(self.target) { tabBarController, index in
            tabBarController.selectedIndex = index
        }
    }
}
#endif
