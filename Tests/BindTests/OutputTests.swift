import XCTest
@testable import Bind

final class OutputTests: XCTestCase {
    func testInitialNoValue() {
        let output = MutableOutput<String>()
        output.bind { _ in
            XCTFail("should not be called as Output has no value set")
        }
    }

    func testInitialValue() {
        let output = MutableOutput<String>(value: "Test")
        var closureCalled: Bool = false
        output.debug(identifier: "123").bind { value in
            XCTAssertEqual("Test", value)
            closureCalled = true
        }
        XCTAssertEqual(closureCalled, true)
    }

    func testBinderIsCalled() {
        let testObject = BindableMock()

        let output = MutableOutput<String>()
        output.bind(to: testObject.binding.text)

        XCTAssertNil(testObject.text)

        output.update(withValue: "Test")

        XCTAssertEqual(testObject.text, "Test")
    }

    func testMultipleBinderIsCalled() {
        let testObjectOne = BindableMock()
        let testObjectTwo = BindableMock()

        let output = MutableOutput<String>()
        output.bind(to: [testObjectOne.binding.text,
                         testObjectTwo.binding.text])

        XCTAssertNil(testObjectOne.text)
        XCTAssertNil(testObjectTwo.text)

        output.update(withValue: "Test")

        XCTAssertEqual(testObjectOne.text, "Test")
        XCTAssertEqual(testObjectTwo.text, "Test")
    }

    func testUnbind() {
        let testObject = BindableMock()

        let output = MutableOutput<String>()
        let subscription = output.bind(to: testObject.binding.text)

        XCTAssertNil(testObject.text)

        output.update(withValue: "Test")

        XCTAssertEqual(testObject.text, "Test")

        output.unbind(for: subscription)

        output.update(withValue: "New Test")

        XCTAssertEqual(testObject.text, "Test")
    }

    func testCombine() {
        let output1 = MutableOutput<Bool>()
        let output2 = MutableOutput<Bool>()

        var outputValue1: Bool?
        var outputValue2: Bool?

        MutableOutput<Bool>.combine(output1, output2).bind { value1, value2 in
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

    func testCombineArray() {
        let output1 = MutableOutput<Bool>()
        let output2 = MutableOutput<Bool>()
        let output3 = MutableOutput<Bool>()

        var outputValue1: Bool?
        var outputValue2: Bool?
        var outputValue3: Bool?

        MutableOutput<Bool>.combine(outputs: [output1, output2, output3]).bind { valuesArray in
            outputValue1 = valuesArray[0]
            outputValue2 = valuesArray[1]
            outputValue3 = valuesArray[2]
        }

        XCTAssertEqual(outputValue1, nil)
        XCTAssertEqual(outputValue2, nil)
        XCTAssertEqual(outputValue3, nil)

        output1.update(withValue: true)

        XCTAssertEqual(outputValue1, nil)
        XCTAssertEqual(outputValue2, nil)
        XCTAssertEqual(outputValue3, nil)

        output2.update(withValue: true)

        XCTAssertEqual(outputValue1, nil)
        XCTAssertEqual(outputValue2, nil)
        XCTAssertEqual(outputValue3, nil)

        output3.update(withValue: true)

        XCTAssertEqual(outputValue1, true)
        XCTAssertEqual(outputValue2, true)
        XCTAssertEqual(outputValue3, true)

        output1.update(withValue: false)

        XCTAssertEqual(outputValue1, false)
        XCTAssertEqual(outputValue2, true)
        XCTAssertEqual(outputValue3, true)
    }

    func testCombineTwoTypes() {
        let output1 = MutableOutput<Bool>()
        let output2 = MutableOutput<String>()

        var outputValue1: Bool?
        var outputValue2: String?

        MutableOutput<Bool>
            .combine(output1, output2)
            .bind { value1, value2 in
                outputValue1 = value1
                outputValue2 = value2
            }

        XCTAssertNil(outputValue1)
        XCTAssertNil(outputValue2)

        output1.update(withValue: true)

        XCTAssertNil(outputValue1)
        XCTAssertNil(outputValue2)

        output2.update(withValue: "test")

        XCTAssertEqual(outputValue1, true)
        XCTAssertEqual(outputValue2, "test")

        output1.update(withValue: false)

        XCTAssertEqual(outputValue1, false)
        XCTAssertEqual(outputValue2, "test")
    }

    func testMap() {
        //swiftlint:disable:next nesting
        enum TestEnum {
            case one
            case two
        }

        let value = MutableOutput<TestEnum>()

        let mappedValue: MutableOutput<String> =
            value
                .map { type in
                    switch type {
                    case .one:
                        return "one"
                    case .two:
                        return "two"
                    }
                }
                .asMutable()

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

        let value = MutableOutput<TestEnum>()

        let mappedValue: MutableOutput<String> =
            value
                .flatMap { type in
                    switch type {
                    case .one:
                        return Output(value: "one")
                    case .two:
                        return Output(value: "two")
                    }
                }
                .asMutable()

        value.update(withValue: .one)
        XCTAssertEqual(mappedValue.latest, "one")

        value.update(withValue: .two)
        XCTAssertEqual(mappedValue.latest, "two")

        value.update(withValue: .one)
        XCTAssertEqual(mappedValue.latest, "one")
    }

    func testFilter() {
        let value = MutableOutput<String>()

        let filteredValue = value
            .filter { string in
                return string.contains("test")
            }

        value.update(withValue: "first test")
        XCTAssertEqual(filteredValue.latest, "first test")

        value.update(withValue: "not")
        XCTAssertEqual(filteredValue.latest, "first test")

        value.update(withValue: "second test")
        XCTAssertEqual(filteredValue.latest, "second test")
    }

    func testMerge() {
        let output1 = MutableOutput<Int>()
        let output2 = MutableOutput<Int>()

        let merge = Output.merge(output1, output2)

        XCTAssertNil(merge.latest)

        output1.update(withValue: 1)
        XCTAssertEqual(merge.latest, 1)

        output1.update(withValue: 2)
        XCTAssertEqual(merge.latest, 2)

        output2.update(withValue: 1)
        XCTAssertEqual(merge.latest, 1)

        output2.update(withValue: 5)
        XCTAssertEqual(merge.latest, 5)
    }

    func testReduceReferenceType() {
        class TestObject { //swiftlint:disable:this nesting
            var currentString: String = ""
        }

        let initial = MutableOutput<Int>()

        let reduced = initial
            .reduce(initial: TestObject()) { current, number -> TestObject in
                var currentString = current.currentString
                currentString += "\(number)"
                current.currentString = currentString
                return current
            }

        for value in [1, 2, 3, 4, 5] {
            initial.update(withValue: value)
        }

        XCTAssertEqual(reduced.latest?.currentString, "12345")
    }

    func testReduceValueType() {
        let initial = MutableOutput<Int>()

        let reduced = initial.reduce(initial: 0, nextPartialResult: +)

        for value in [1, 2, 3, 4, 5] {
            initial.update(withValue: value)
        }

        XCTAssertEqual(reduced.latest, 15)
    }

    func testInitialValueFunctionChain() {
        let initial = MutableOutput<Int>().initial(10)
        XCTAssertEqual(initial.latest, 10)

        let alreadyPopulated = MutableOutput<Int>(value: 5).initial(10)
        XCTAssertEqual(alreadyPopulated.latest, 5)

        let left = MutableOutput(value: 3)
        let right = MutableOutput<Int>()

        let combined = MutableOutput
            .combine(left, right)
            .map(+)
            .initial(20)

        XCTAssertEqual(combined.latest, 20)

        left.update(withValue: 4)
        XCTAssertEqual(combined.latest, 20)

        right.update(withValue: 6)
        XCTAssertEqual(combined.latest, 10)
    }

    func testDebug() {
        let printer = PrinterMock()
        let output1 = MutableOutput<Bool>(printer: printer)

        XCTAssertTrue(printer.printValues.isEmpty)

        output1
            .debug(identifier: "123")
            .bind { _ in }

        XCTAssertEqual(printer.printValues.count, 3)
        XCTAssertEqual(printer.printValues[0], "---")
        XCTAssertEqual(printer.printValues[1], "Binding 123 (MutableOutput<Bool>) to (Function)")
        XCTAssertEqual(printer.printValues[2], "To bindings: [Bind.Subscription: (Function)]")

        output1.update(withValue: false)

        XCTAssertEqual(printer.printValues.count, 8)
        XCTAssertEqual(printer.printValues[3], "---")
        XCTAssertEqual(printer.printValues[4], "Will update value for 123 (MutableOutput<Bool>) to false")
        XCTAssertEqual(printer.printValues[5], "To bindings: [Bind.Subscription: (Function)]")
        XCTAssertEqual(printer.printValues[6], "Did update value for 123 (MutableOutput<Bool>) to false")
        XCTAssertEqual(printer.printValues[7], "To bindings: [Bind.Subscription: (Function)]")
    }
}
