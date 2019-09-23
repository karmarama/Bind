#if !os(macOS)
import UIKit

extension UIViewController: BindableCompatible {}

extension Bindable where TargetType: UIViewController {
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
