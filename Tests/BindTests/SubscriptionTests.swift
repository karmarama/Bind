import XCTest
@testable import Bind

final class SubscriptionTests: XCTestCase {
    func testUnsubscribe() {
        let mockUnbindable = UnbindableMock()
        let subscription = Subscription(unbinder: mockUnbindable)

        subscription.unsubscribe()

        XCTAssertEqual(mockUnbindable.unbindCalledCount, 1)
        XCTAssertEqual(mockUnbindable.unbindSubscriptionArray.count, 1)
        XCTAssertEqual(mockUnbindable.unbindSubscriptionArray.first, subscription)
    }

    func testSubscriptionContainerAdd() {
        let mockUnbindable = UnbindableMock()
        let subscription = Subscription(unbinder: mockUnbindable)
        let container = SubscriptionContainer()

        subscription.add(to: container)

        XCTAssertEqual(container.container.count, 1)
    }

    func testSubscriptionContainerUnsubscribe() {
        let mockUnbindable = UnbindableMock()
        let subscription = Subscription(unbinder: mockUnbindable)

        let container = SubscriptionContainer()
        subscription.add(to: container)

        XCTAssertEqual(container.container.count, 1)

        container.unsubscribe()

        XCTAssertEqual(container.container.count, 0)
        XCTAssertEqual(mockUnbindable.unbindCalledCount, 1)
    }
}
