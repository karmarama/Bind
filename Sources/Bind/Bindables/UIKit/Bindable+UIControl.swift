#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UIControl {
    var isSelected: Binder<Bool> {
        return Binder<Bool>(self.target) { control, isSelected in
            control.isSelected = isSelected
        }
    }
}
#endif
