#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UITextField {
    var borderColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { textField, borderColor in
            textField.layer.borderColor = borderColor.cgColor
        }
    }

    var text: Binder<String> {
        return Binder<String>(self.target) { textField, text in
            textField.text = text
        }
    }
}
#endif
