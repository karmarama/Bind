import Foundation
@testable import Trigger

extension Trigger {
    var latest: Value? {
        var value: Value?

        bind { current in
            value = current
        }

        return value
    }
}
