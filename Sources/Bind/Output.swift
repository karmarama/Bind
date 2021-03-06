// MARK: - Core
public class Output<Value>: Unbindable {
    public struct Printer: Printable {
        public init() {}
        public func print(_ value: String) {
            Swift.print(value)
        }
    }

    private var observers = [Subscription: ((Value) -> Void)]()
    private var debugIdentifier: String?
    private let printer: Printable
    private(set) var value: Value?

    public init(value: Value? = nil, printer: Printable = Printer()) {
        self.value = value
        self.printer = printer
    }

    func update(withValue value: Value, shouldStore: Bool) {
        if let identifier = debugIdentifier {
            printer.print("---")
            printer.print("Will update value for \(identifier) (\(type(of: self))) to \(value)")
            printer.print("To bindings: \(observers)")
        }

        if shouldStore {
            self.value = value
        }

        observers
            .values
            .forEach { closure in
                closure(value)
            }

        if let identifier = debugIdentifier {
            printer.print("Did update value for \(identifier) (\(type(of: self))) to \(value)")
            printer.print("To bindings: \(observers)")
        }
    }

    public func update(withValue value: Value) {
        update(withValue: value, shouldStore: true)
    }

    @discardableResult public func bind(to binder: Binder<Value>) -> Subscription {
        return bind(binder.on)
    }

    public func bind(to binders: [Binder<Value>]) {
        for binder in binders {
            bind(binder.on)
        }
    }

    @discardableResult public func bind(_ closure: @escaping (Value) -> Void) -> Subscription {
        let subscription = Subscription(unbinder: self)
        observers[subscription] = closure

        if let identifier = debugIdentifier {
            printer.print("---")
            printer.print("Binding \(identifier) (\(type(of: self))) to \(String(describing: closure))")
            printer.print("To bindings: \(observers)")
        }

        if let value = value {
            if let identifier = debugIdentifier {
                printer.print("Initial value for \(identifier) (\(type(of: self))) is \(value)")
            }
            closure(value)
        }

        return subscription
    }

    /**
     `initial` allows the caller to specify an initial value to be populated into the Output through another mechanism
     other than the initialiser. If a value is already populated, this function just returns the receiver without doing
     anything.
     - Parameter value: The initial value
     - Returns: The same Output but with the initial value populated
     - Note: This is useful when needing to setup a functional chain with an initial value that does not
             trigger the chain to occur, e.g. setting the initial value at the end.
     */
    public func initial(_ value: Value) -> Output<Value> {
        if self.value == nil {
            update(withValue: value)
        }

        return self
    }

    public func debug(identifier: String) -> Output<Value> {
        debugIdentifier = identifier
        return self
    }

    public func unbind(for subscription: Subscription) {
        observers[subscription] = nil
    }
}

public protocol Printable {
    func print(_ value: String)
}

// MARK: - Functional extensions
public extension Output {
    /**
     `combine(outputs:)` combine all individual values of the output's collection into a single output that emits a
     collection of those values.
     - Parameter outputs: The collection of outputs
     - Returns: An `Output` that returns a collection made of each value of all individual outputs
     - Note: Receiver does not retain the array of Outputs.
     */
    static func combine(outputs: [Output<Value>]) -> Output<[Value]> {
        let returnOutput = Output<[Value]>()
        let weaks = outputs.map(Weak.init)

        for output in weaks {
            output.value?.bind { _ in
                let values = weaks.compactMap { $0.value }.compactMap { $0.value }

                if values.count == weaks.count {
                    returnOutput.update(withValue: values)
                }
            }
        }

        return returnOutput
    }

    /**
     `combine(output1:,output2)` combines two outputs that emit the same value into one output that emits a
     tuple of those values.
     - Returns: An `Output` that emits a tuple with the values of each output
     - Note: Receiver does not retain output1 and output2.
     */
    static func combine(_ output1: Output<Value>, _ output2: Output<Value>) -> Output<(Value, Value)> {
        let output = Output<(Value, Value)>()

        output1.bind { [weak output2] value1 in
            if let value2 = output2?.value {
                output.update(withValue: (value1, value2))
            }
        }

        output2.bind { [weak output1] value2 in
            if let value1 = output1?.value {
                output.update(withValue: (value1, value2))
            }
        }

        return output
    }

    /**
     `combine(output1:,output2)` combines two outputs that emit the different values into one output that emits a
     tuple of those values.
     - Returns: An `Output` that emits a tuple with the values of each output
     - Note: Receiver does not retain output1 and output2.
     */
    static func combine<A, B>(_ output1: Output<A>, _ output2: Output<B>) -> Output<(A, B)> {
        let output = Output<(A, B)>()

        output1.bind { [weak output2] value1 in
            if let value2 = output2?.value {
                output.update(withValue: (value1, value2))
            }
        }

        output2.bind { [weak output1] value2 in
            if let value1 = output1?.value {
                output.update(withValue: (value1, value2))
            }
        }

        return output
    }

    static func merge(_ output1: Output<Value>, _ output2: Output<Value>) -> Output<Value> {
        let output = Output<Value>()

        output1.bind { value1 in
            output.update(withValue: value1)
        }

        output2.bind { value2 in
            output.update(withValue: value2)
        }

        return output
    }

    /**
     `map` performs a transform over a Value and returns it as `TransformedValue` wrapped in its own `Output`
     - Parameter transform: The function that transform `Value` into `TransformedValue`
     - Returns: An `Output` of type `TransformedValue`
     */
    func map<TransformedValue>(_ transform: @escaping (Value) -> TransformedValue) -> Output<TransformedValue> {
        let output = Output<TransformedValue>()

        bind { value in
            output.update(withValue: transform(value))
        }

        return output
    }

    /**
     `flatMap` performs a transform over a Value and returns it as `Output<TransformedValue>` by flattening
     the nested Outputs
     - Parameter transform: The function that transform `Value` into a new `Output` of type `<TransformedValue>`
     - Returns: A flattened `Output` of type `TransformedValue`
     */
    func flatMap<TransformedValue>(_ transform: @escaping (Value) -> Output<TransformedValue>)
        -> Output<TransformedValue> {
            let output = Output<TransformedValue>()

            bind { value in
                let resultOutput = transform(value)

                // Bind to the resultOutput to extract the value so it can 'flatten'
                resultOutput.bind { value in
                    output.update(withValue: value)
                }
            }

            return output
    }

    /**
     `filter` passes the Value through a predicate, if the functions true the `Value` is output, otherwise
     it is filtered out.
     - Parameter filter: The function that predicates on the `Value` to determine if it is output
     - Returns: A new `Output` which predicates on the `Value` before outputting
     */
    func filter(_ filter: @escaping (Value) -> Bool) -> Output<Value> {
        let output = Output<Value>()

        bind { value in
            if filter(value) {
                output.update(withValue: value)
            }
        }

        return output
    }

    /**
     Returns a new output that is the result of combining the outputted elements of the receiver
     using the given closure.
     - Parameter initial: The value to use as the initial accumulating value.
     initialResult is passed to nextPartialResult the first time the closure is executed.
     - Parameter nextPartialResult:
     A closure that combines an accumulating value and the next value of the Output into a new accumulating
     value that is then output to any binders.
     - Returns: A new `Output` which acts as a tap of the combined accumulating values
     */
    func reduce<Result>(initial: Result, nextPartialResult: @escaping (Result, Value) -> Result) -> Output<Result> {
        let output = Output<Result>()

        bind { value in
            let result = nextPartialResult(output.value ?? initial, value)
            output.update(withValue: result)
        }

        return output
    }
}

public extension Output where Value: Equatable {

    /**
     Returns a new output that filters out any contiguous repeating `Value`.
     - Returns: A new `Output` which only emits a new value, when the new value is not equal to the previous value
     */
    func ignoringDuplicates() -> Output<Value> {
        let output = Output<Value>()

        var initial = self.value

        let filtered = filter { value in
            value != initial
        }

        filtered.bind { new in
            initial = self.value
            output.update(withValue: new)
        }

        return filtered
    }
}
