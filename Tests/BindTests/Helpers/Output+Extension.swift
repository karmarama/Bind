@testable import Bind

extension Output {
    var latest: Value? {
        var value: Value?

        bind { current in
            value = current
        }

        return value
    }
}
