#if !os(macOS) && !os(watchOS)
import UIKit

public extension NSLayoutConstraint: BindableCompatible {}

public extension Bindable where TargetType: NSLayoutConstraint {
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
