#if !os(macOS) && !os(watchOS)
import UIKit

public extension Bindable where TargetType: UISegmentedControl {
    var selectedIndex: Binder<Int> {
        return Binder<Int>(self.target) { segmentedControl, index in
            segmentedControl.selectedSegmentIndex = index
        }
    }

    var titles: Binder<[String]> {
        return Binder<[String]>(self.target) { segmentedControl, titles in
            segmentedControl.removeAllSegments()
            for (offset, title) in titles.enumerated() {
                segmentedControl.insertSegment(withTitle: title, at: offset, animated: false)
            }
        }
    }

    func title(for index: Int) -> Binder<String> {
        return Binder<String>(self.target) { segmentedControl, title in
            segmentedControl.setTitle(title, forSegmentAt: index)
        }
    }
}
#endif
