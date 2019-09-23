#if !os(macOS)
import UIKit

extension Bindable where TargetType: UIActivityIndicatorView {
    var isAnimating: Binder<Bool> {
        return Binder<Bool>(self.target) { indicator, isAnimating in
            if isAnimating {
                indicator.startAnimating()
            } else {
                indicator.stopAnimating()
            }
        }
    }
}
#endif
