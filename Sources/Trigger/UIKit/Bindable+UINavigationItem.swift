#if !os(macOS)
import UIKit

extension UINavigationItem: BindableCompatible {}

extension Bindable where TargetType: UINavigationItem {
    var title: Binder<String> {
        return Binder<String>(self.target) { navigationItem, title in
            navigationItem.title = title
        }
    }
}
#endif
