import Foundation

public final class Subscription {
    fileprivate let uuid: UUID
    fileprivate weak var unbinder: Unbindable?

    public init(unbinder: Unbindable) {
        self.uuid = UUID()
        self.unbinder = unbinder
    }

    public func add(to container: SubscriptionContainer) {
        container.append(self)
    }

    public func unsubscribe() {
        unbinder?.unbind(for: self)
    }
}

extension Subscription: Hashable {
    public static func == (lhs: Subscription, rhs: Subscription) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    public func hash(into hasher: inout Hasher) {
        return uuid.hash(into: &hasher)
    }
}

public final class SubscriptionContainer {
    private var container: [Subscription] = []

    public init() {}

    public func append(_ element: Subscription) {
        container.append(element)
    }

    public func unsubscribe() {
        for subscription in container {
            subscription.unsubscribe()
        }
    }
}
