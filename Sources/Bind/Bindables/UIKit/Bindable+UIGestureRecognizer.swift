#if !os(macOS) && !os(watchOS)
import UIKit

extension UIGestureRecognizer: BindableCompatible {}

public extension Bindable where TargetType: UIGestureRecognizer {
    var isEnabled: Binder<Bool> {
        return Binder<Bool>(self.target) { gestureRecognizer, enabled in
            gestureRecognizer.isEnabled = enabled
        }
    }
}
#endif
