#if !os(macOS)
import UIKit

extension NSLayoutConstraint: BindableCompatible {}

extension Bindable where TargetType: NSLayoutConstraint {
    var isActive: Binder<Bool> {
        return Binder<Bool>(self.target) { constraint, bool in
            constraint.isActive = bool
        }
    }

    var isInactive: Binder<Bool> {
        return Binder<Bool>(self.target) { constraint, bool in
            constraint.isActive = !bool
        }
    }
}
#endif
