#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UIActivityIndicatorView {
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
