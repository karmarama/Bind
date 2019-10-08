@testable import Bind

final class UnbindableMock: Unbindable {
    var unbindCalledCount = 0
    var unbindSubscriptionArray = [Subscription]()
    func unbind(for subscription: Subscription) {
        unbindCalledCount += 1
        unbindSubscriptionArray.append(subscription)
    }
}
