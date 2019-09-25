import Foundation
@testable import Trigger

public class TestObject: BindableCompatible {
    var text: String?
}

public extension Bindable where TargetType: TestObject {
    var text: Binder<String> {
        return Binder<String>(self.target) { testObject, text in
            testObject.text = text
        }
    }
}
