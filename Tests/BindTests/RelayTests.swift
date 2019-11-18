import XCTest
@testable import Bind

final class RelayTests: XCTestCase {
    func testRelayNotFired() {
        let expect = expectation(description: "not called")
        expect.isInverted = true

        let relay = Relay<Void>()

        relay.bind { _ in
            expect.fulfill()
        }

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRelayFired() {
        let expect = expectation(description: "called")

        let relay = Relay<Void>()

        relay.bind { _ in
            expect.fulfill()
        }

        relay.fire()

        waitForExpectations(timeout: 0.1, handler: nil)
    }

    func testRelayIsStateless() {
        let output = Output<Int>()
        let relay = Relay<Int>()

        var counter = 0

        Output
            .combine(output, relay)
            .bind { _ in
                counter += 1
            }

        XCTAssertEqual(counter, 0)

        output.update(withValue: 1)
        XCTAssertEqual(counter, 0)

        output.update(withValue: 2)
        XCTAssertEqual(counter, 0)

        relay.update(withValue: 1)
        XCTAssertEqual(counter, 1)

        relay.update(withValue: 1)
        XCTAssertEqual(counter, 2)

        output.update(withValue: 1)
        XCTAssertEqual(counter, 2)
    }
}
