import XCTest
@testable import Bind

final class RelayTests: XCTestCase {
    func testRelayNotFired() {
        let expect = expectation(description: "not called")
        expect.isInverted = true

        let relay = Relay()

        relay.bind { _ in
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRelayFired() {
        let expect = expectation(description: "called")

        let relay = Relay()

        relay.bind { _ in
            expect.fulfill()
        }

        relay.fire()

        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
