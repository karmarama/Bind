#if !os(macOS) && !os(watchOS)
import UIKit

extension Bindable where TargetType: UISearchBar {
    var placeholder: Binder<String> {
        return Binder<String>(self.target) { searchbar, placeholder in
           searchbar.placeholder = placeholder
        }
    }
}
#endif
