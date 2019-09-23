import Foundation

final class Subscription {
    fileprivate let uuid: UUID
    fileprivate weak var unbinder: Unbindable?

    init(uuid: UUID, unbinder: Unbindable) {
        self.uuid = uuid
        self.unbinder = unbinder
    }

    func add(to container: SubscriptionContainer) {
        container.append(self)
    }

    func unsubscribe() {
        unbinder?.unbind(for: self)
    }
}

extension Subscription: Hashable {
    static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        return uuid.hash(into: &hasher)
    }
}

final class SubscriptionContainer {
    private var container: [Subscription] = []

    func append(_ element: Subscription) {
        container.append(element)
    }

    func unsubscribe() {
        for subscription in container {
            subscription.unsubscribe()
        }
    }
}
