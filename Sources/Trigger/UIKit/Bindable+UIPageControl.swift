#if !os(macOS)
import UIKit

extension Bindable where TargetType: UIPageControl {
    var page: Binder<Int> {
        return Binder<Int>(self.target) { pageControl, page in
            pageControl.currentPage = page
        }
    }
}
#endif
