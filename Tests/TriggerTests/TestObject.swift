import Foundation
@testable import Trigger

class TestObject: BindableCompatible {
    var text: String?
}

extension Bindable where TargetType: TestObject {
    var text: Binder<String> {
        return Binder<String>(self.target) { testObject, text in
            testObject.text = text
        }
    }
}
