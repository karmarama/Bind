import Foundation
@testable import Trigger

public extension Trigger {
    var latest: Value? {
        var value: Value?

        bind { current in
            value = current
        }

        return value
    }
}
