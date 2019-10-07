@testable import Bind

final class BindableMock: BindableCompatible {
    var text: String?
}

extension Bindable where TargetType: BindableMock {
    var text: Binder<String> {
        return Binder<String>(self.target) { testObject, text in
            testObject.text = text
        }
    }
}
