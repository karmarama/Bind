#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UITabBar {
    var unselectedItemColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { tabBar, color in
            if #available(iOS 10.0, *) {
                tabBar.unselectedItemTintColor = color
            }
        }
    }
}
#endif
