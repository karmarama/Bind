#if !os(macOS) && !os(watchOS)
import UIKit

extension Bindable where TargetType: UILabel {
    var text: Binder<String> {
        return Binder<String>(self.target) { label, text in
            label.text = text
        }
    }

    var textColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { label, textColor in
            label.textColor = textColor
        }
    }
    
    var attributedText: Binder<NSAttributedString?> {
        return Binder<NSAttributedString?>(self.target) { label, attributedText in
            label.attributedText = attributedText
        }
    }
}
#endif
