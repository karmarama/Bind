#if !os(macOS)
import UIKit

extension Bindable where TargetType: UISwitch {
    var isOn: Binder<Bool> {
        return Binder<Bool>(self.target) { toggle, isOn in
            toggle.isOn = isOn
        }
    }
}
#endif
