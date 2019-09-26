#if !os(watchOS) && !os(tvOS)
import WebKit

public extension Bindable where TargetType: WKWebView {
    var fileURL: Binder<URL> {
        return Binder<URL>(self.target) { webView, fileURL in
            webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
        }
    }
}
#endif

