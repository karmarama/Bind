#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UIPageControl {
    var page: Binder<Int> {
        return Binder<Int>(self.target) { pageControl, page in
            pageControl.currentPage = page
        }
    }
}
#endif
