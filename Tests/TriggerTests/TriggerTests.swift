import XCTest

@testable import Trigger

final class OutputTests: XCTestCase {
  func testInitialNoValue() {
    let output = Output<String>()
    output.bind { _ in
      XCTFail("should not be called as Output has no value set")
    }
  }
  
  func testInitialValue() {
    let output = Output<String>(value: "Test")
    var closureCalled: Bool = false
    output.debug(identifier: "123").bind { value in
      XCTAssertEqual("Test", value)
      closureCalled = true
    }
    XCTAssertEqual(closureCalled, true)
  }
  
  func testBinderIsCalled() {
    let testObject = TestObject()
    
    let output = Output<String>()
    output.bind(to: testObject.binding.text)
    
    XCTAssertNil(testObject.text)
    
    output.update(withValue: "Test")
    
    XCTAssertEqual(testObject.text, "Test")
  }
  
  func testMultipleBinderIsCalled() {
    let testObjectOne = TestObject()
    let testObjectTwo = TestObject()
    
    let output = Output<String>()
    output.bind(to: [testObjectOne.binding.text,
                      testObjectTwo.binding.text])
    
    XCTAssertNil(testObjectOne.text)
    XCTAssertNil(testObjectTwo.text)
    
    output.update(withValue: "Test")
    
    XCTAssertEqual(testObjectOne.text, "Test")
    XCTAssertEqual(testObjectTwo.text, "Test")
  }
  
  func testToggleWithValue() {
    let output = Output(value: true)
    XCTAssertEqual(output.latest, true)
    
    output.invert()
    
    XCTAssertEqual(output.latest, false)
  }
  
  func testToggleWithNoValue() {
    let output = Output<Bool>()
    XCTAssertNil(output.latest)
    
    output.invert()
    XCTAssertNil(output.latest)
  }
  
  func testUnbind() {
    let testObject = TestObject()
    
    let output = Output<String>()
    let subscription = output.bind(to: testObject.binding.text)
    
    XCTAssertNil(testObject.text)
    
    output.update(withValue: "Test")
    
    XCTAssertEqual(testObject.text, "Test")
    
    output.unbind(for: subscription)
    
    output.update(withValue: "New Test")
    
    XCTAssertEqual(testObject.text, "Test")
  }
  
  func testCombine() {
    let output1 = Output<Bool>()
    let output2 = Output<Bool>()
    
    var outputValue1: Bool?
    var outputValue2: Bool?
    
    Output<Bool>.combine(output1, output2).bind { value1, value2 in
      outputValue1 = value1
      outputValue2 = value2
    }
    
    XCTAssertEqual(outputValue1, nil)
    XCTAssertEqual(outputValue2, nil)
    
    output1.update(withValue: true)
    
    XCTAssertEqual(outputValue1, nil)
    XCTAssertEqual(outputValue2, nil)
    
    output2.update(withValue: true)
    
    XCTAssertEqual(outputValue1, true)
    XCTAssertEqual(outputValue2, true)
    
    output1.update(withValue: false)
    
    XCTAssertEqual(outputValue1, false)
    XCTAssertEqual(outputValue2, true)
  }
  
  func testMap() {
    //swiftlint:disable:next nesting
    enum TestEnum {
      case one
      case two
    }
    
    let value = Output<TestEnum>()
    
    let mappedValue: Output<String> =
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
    
    let value = Output<TestEnum>()
    
    let mappedValue: Output<String> =
      value
        .flatMap { type in
          switch type {
          case .one:
            return Output(value: "one")
          case .two:
            return Output(value: "two")
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
    let output1 = Output<Bool>(printer: printer)
    
    XCTAssertTrue(printer.printValues.isEmpty)
    
    output1
      .debug(identifier: "123")
      .bind { _ in }
    
    XCTAssertEqual(printer.printValues.count, 3)
    XCTAssertEqual(printer.printValues[0], "---")
    XCTAssertEqual(printer.printValues[1], "Binding 123 (Trigger<Bool>) to (Function)")
    XCTAssertEqual(printer.printValues[2], "To bindings: [Trigger.Subscription: (Function)]")
    
    output1.update(withValue: false)
    
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
