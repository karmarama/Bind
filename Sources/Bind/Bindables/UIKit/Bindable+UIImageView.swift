#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UIImageView {
    var image: Binder<UIImage> {
        return Binder<UIImage>(self.target) { imageView, image in
            imageView.image = image
        }
    }
}
#endif
