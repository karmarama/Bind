#if !os(macOS)
import UIKit

extension Bindable where TargetType: UIButton {
    func title(for state: UIControl.State = .normal) -> Binder<String> {
        return Binder<String>(self.target) { button, title in
            button.setTitle(title, for: state)
        }
    }

    func attributedTitle(for state: UIControl.State = .normal) -> Binder<NSAttributedString?> {
        return Binder<NSAttributedString?>(self.target) { button, attributedTitle in
            button.setAttributedTitle(attributedTitle, for: state)
        }
    }

    func image(for state: UIControl.State = .normal) -> Binder<UIImage> {
        return Binder<UIImage>(self.target) { button, image in
            button.setImage(image, for: state)
        }
    }

    func backgroundImage(for state: UIControl.State = .normal) -> Binder<UIImage> {
        return Binder<UIImage>(self.target) { button, image in
            button.setBackgroundImage(image, for: state)
        }
    }

    func action(for event: UIControl.Event = .touchUpInside) -> Binder<(Any, Selector)> {
        return Binder<(Any, Selector)>(self.target) { button, target in
            button.addTarget(target.0, action: target.1, for: event)
        }
    }

    var isEnabled: Binder<Bool> {
        return Binder<Bool>(self.target) { button, isEnabled in
            button.isEnabled = isEnabled
        }
    }
}
#endif
