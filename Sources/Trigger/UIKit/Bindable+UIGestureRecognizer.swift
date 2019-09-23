#if !os(macOS)
import UIKit

extension UIGestureRecognizer: BindableCompatible {}

extension Bindable where TargetType: UIGestureRecognizer {
    var isEnabled: Binder<Bool> {
        return Binder<Bool>(self.target) { gestureRecognizer, enabled in
            gestureRecognizer.isEnabled = enabled
        }
    }
}
#endif
