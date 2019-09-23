#if !os(macOS)
import UIKit

extension Bindable where TargetType: UITabBar {
    var unselectedItemColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { tabBar, color in
            tabBar.unselectedItemTintColor = color
        }
    }
}
#endif
