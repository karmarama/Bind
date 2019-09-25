#if !os(macOS) && !os(tvOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UISwitch {
    var isOn: Binder<Bool> {
        return Binder<Bool>(self.target) { toggle, isOn in
            toggle.isOn = isOn
        }
    }
}
#endif
