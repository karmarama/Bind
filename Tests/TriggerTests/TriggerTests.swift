import XCTest

@testable import Trigger

public final class TriggerTests: XCTestCase {
    func testInitialNoValue() {
          let trigger = Trigger<String>()
          trigger.bind { _ in
              XCTFail("should not be called as Trigger has no value set")
          }
      }

      func testInitialValue() {
          let trigger = Trigger<String>(value: "Test")
          var closureCalled: Bool = false
          trigger.debug(identifier: "123").bind { value in
              XCTAssertEqual("Test", value)
              closureCalled = true
          }
          XCTAssertEqual(closureCalled, true)
      }

      func testBinderIsCalled() {
          let testObject = TestObject()

          let trigger = Trigger<String>()
          trigger.bind(to: testObject.binding.text)

          XCTAssertNil(testObject.text)

          trigger.update(withValue: "Test")

          XCTAssertEqual(testObject.text, "Test")
      }

      func testMultipleBinderIsCalled() {
          let testObjectOne = TestObject()
          let testObjectTwo = TestObject()

          let trigger = Trigger<String>()
          trigger.bind(to: [testObjectOne.binding.text,
                            testObjectTwo.binding.text])

          XCTAssertNil(testObjectOne.text)
          XCTAssertNil(testObjectTwo.text)

          trigger.update(withValue: "Test")

          XCTAssertEqual(testObjectOne.text, "Test")
          XCTAssertEqual(testObjectTwo.text, "Test")
      }

      func testToggleWithValue() {
          let trigger = Trigger(value: true)
          XCTAssertEqual(trigger.latest, true)

          trigger.invert()

          XCTAssertEqual(trigger.latest, false)
      }

      func testToggleWithNoValue() {
          let trigger = Trigger<Bool>()
          XCTAssertNil(trigger.latest)

          trigger.invert()
          XCTAssertNil(trigger.latest)
      }

      func testUnbind() {
          let testObject = TestObject()

          let trigger = Trigger<String>()
          let subscription = trigger.bind(to: testObject.binding.text)

          XCTAssertNil(testObject.text)

          trigger.update(withValue: "Test")

          XCTAssertEqual(testObject.text, "Test")

          trigger.unbind(for: subscription)

          trigger.update(withValue: "New Test")

          XCTAssertEqual(testObject.text, "Test")
      }

      func testCombine() {
          let trigger1 = Trigger<Bool>()
          let trigger2 = Trigger<Bool>()

          var triggerValue1: Bool?
          var triggerValue2: Bool?

          Trigger<Bool>.combine(trigger1, trigger2).bind { value1, value2 in
              triggerValue1 = value1
              triggerValue2 = value2
          }

          XCTAssertEqual(triggerValue1, nil)
          XCTAssertEqual(triggerValue2, nil)

          trigger1.update(withValue: true)

          XCTAssertEqual(triggerValue1, nil)
          XCTAssertEqual(triggerValue2, nil)

          trigger2.update(withValue: true)

          XCTAssertEqual(triggerValue1, true)
          XCTAssertEqual(triggerValue2, true)

          trigger1.update(withValue: false)

          XCTAssertEqual(triggerValue1, false)
          XCTAssertEqual(triggerValue2, true)
      }

      func testMap() {
          //swiftlint:disable:next nesting
          enum TestEnum {
              case one
              case two
          }

          let value = Trigger<TestEnum>()

          let mappedValue: Trigger<String> =
              value
                  .map { type in
                      switch type {
                      case .one:
                          return "one"
                      case .two:
                          return "two"
                      }
                  }

          value.update(withValue: .one)
          XCTAssertEqual(mappedValue.latest, "one")

          value.update(withValue: .two)
          XCTAssertEqual(mappedValue.latest, "two")

          value.update(withValue: .one)
          XCTAssertEqual(mappedValue.latest, "one")
      }

      func testFlatMap() {
          //swiftlint:disable:next nesting
          enum TestEnum {
              case one
              case two
          }

          let value = Trigger<TestEnum>()

          let mappedValue: Trigger<String> =
              value
                  .flatMap { type in
                      switch type {
                      case .one:
                          return Trigger(value: "one")
                      case .two:
                          return Trigger(value: "two")
                      }
                  }

          value.update(withValue: .one)
          XCTAssertEqual(mappedValue.latest, "one")

          value.update(withValue: .two)
          XCTAssertEqual(mappedValue.latest, "two")

          value.update(withValue: .one)
          XCTAssertEqual(mappedValue.latest, "one")
      }

      func testDebug() {
          let printer = PrinterMock()
          let trigger1 = Trigger<Bool>(printer: printer)

          XCTAssertTrue(printer.printValues.isEmpty)

          trigger1
              .debug(identifier: "123")
              .bind { _ in }

          XCTAssertEqual(printer.printValues.count, 3)
          XCTAssertEqual(printer.printValues[0], "---")
          XCTAssertEqual(printer.printValues[1], "Binding 123 (Trigger<Bool>) to (Function)")
          XCTAssertEqual(printer.printValues[2], "To bindings: [Trigger.Subscription: (Function)]")

          trigger1.update(withValue: false)

          XCTAssertEqual(printer.printValues.count, 8)
          XCTAssertEqual(printer.printValues[3], "---")
          XCTAssertEqual(printer.printValues[4], "Will update value for 123 (Trigger<Bool>) to false")
           XCTAssertEqual(printer.printValues[5], "To bindings: [Trigger.Subscription: (Function)]")
           XCTAssertEqual(printer.printValues[6], "Did update value for 123 (Trigger<Bool>) to false")
           XCTAssertEqual(printer.printValues[7], "To bindings: [Trigger.Subscription: (Function)]")
      }

    static var allTests = [
        ("testInitialNoValue", testInitialNoValue),
        ("testInitialValue", testInitialValue),
        ("testBinderIsCalled", testBinderIsCalled),
        ("testMultipleBinderIsCalled", testMultipleBinderIsCalled),
        ("testToggleWithValue", testToggleWithValue),
        ("testToggleWithNoValue", testToggleWithNoValue),
        ("testUnbind", testUnbind),
        ("testCombine", testCombine),
        ("testMap",testMap),
        ("testFlatMap",testFlatMap),
        ("testDebug",testDebug),
    ]
}
