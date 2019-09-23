#if !os(macOS)
import UIKit

extension Bindable where TargetType: UIControl {

    var isSelected: Binder<Bool> {
        return Binder<Bool>(self.target) { control, isSelected in
            control.isSelected = isSelected
        }
    }
}
#endif
