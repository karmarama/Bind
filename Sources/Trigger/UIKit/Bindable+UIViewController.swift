#if !os(macOS) && !os(watchOS)
import UIKit

public extension UIViewController: BindableCompatible {}

public extension Bindable where TargetType: UIViewController {
    var title: Binder<String> {
        return Binder<String>(self.target) { viewController, title in
            viewController.title = title
        }
    }

    var tabBarTitle: Binder<String> {
        return Binder<String>(self.target) { viewController, title in
            viewController.tabBarItem.title = title
        }
    }
}
#endif
