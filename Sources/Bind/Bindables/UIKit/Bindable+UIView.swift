#if !os(macOS) && !os(watchOS)
import UIKit

extension UIView: BindableCompatible {}

public extension Bindable where TargetType: UIView {
    var isHidden: Binder<Bool> {
        return Binder<Bool>(self.target) { view, isHidden in
            view.isHidden = isHidden
        }
    }

    var isVisible: Binder<Bool> {
        return Binder<Bool>(self.target) { view, isVisible in
            view.isHidden = !isVisible
        }
    }

    func isVisibleAlpha(animated: Bool = false) -> Binder<Bool> {
        return Binder<Bool>(self.target) { view, isVisible in
            if animated {
                UIView.animate(withDuration: 0.2) {
                    view.alpha = isVisible ? 1 : 0
                }
            } else {
                view.alpha = isVisible ? 1 : 0
            }
        }
    }

    var backgroundColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { view, backgroundColor in
            view.backgroundColor = backgroundColor
        }
    }

    var borderColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { view, borderColor in
            view.layer.borderColor = borderColor.cgColor
        }
    }

    var borderWidth: Binder<CGFloat> {
        return Binder<CGFloat>(self.target) { view, borderWidth in
            view.layer.borderWidth = borderWidth
        }
    }

    var cornerRadius: Binder<CGFloat> {
        return Binder<CGFloat>(self.target) { view, cornerRadius in
            view.layer.cornerRadius = cornerRadius
        }
    }

    var tintColor: Binder<UIColor> {
        return Binder<UIColor>(self.target) { tabBar, color in
            tabBar.tintColor = color
        }
    }

    var isUserInteractionEnabled: Binder<Bool> {
        return Binder<Bool>(self.target) { view, isUserInteractionEnabled in
            view.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }

    var accessibilityIdentifier: Binder<String> {
        return Binder<String>(self.target) { view, accessibilityIdentifier in
            view.accessibilityIdentifier = accessibilityIdentifier
        }
    }

    var areConstraintsActive: Binder<Bool> {
        return Binder<Bool>(self.target) { view, areConstraintsActive in
            view.constraints.forEach { $0.isActive = areConstraintsActive }
        }
    }
}
#endif
