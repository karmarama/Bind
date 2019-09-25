import Foundation

// MARK: - Core
public class Trigger<Value>: Unbindable {
    private struct Printer: Printable {
        func print(_ value: String) {
            Swift.print(value)
        }
    }

    private var observers = [Subscription: ((Value) -> Void)]()
    private var value: Value?
    private var debugIdentifier: String?
    private let printer: Printable

    init(value: Value? = nil, printer: Printable = Printer()) {
        self.value = value
        self.printer = printer
    }

    func update(withValue value: Value) {
        if let identifier = debugIdentifier {
            printer.print("---")
            printer.print("Will update value for \(identifier) (\(type(of: self))) to \(value)")
            printer.print("To bindings: \(observers)")
        }

        self.value = value

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

    @discardableResult func bind(to binder: Binder<Value>) -> Subscription {
        return bind(binder.on)
    }

    func bind(to binders: [Binder<Value>]) {
        for binder in binders {
            bind(binder.on)
        }
    }

    @discardableResult func bind(_ closure: @escaping (Value) -> Void) -> Subscription {
        let subscription = Subscription(uuid: UUID(), unbinder: self)
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

    func debug(identifier: String) -> Trigger<Value> {
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
public extension Trigger {
    static func combine(_ trigger1: Trigger<Value>, _ trigger2: Trigger<Value>) -> Trigger<(Value, Value)> {
        let trigger = Trigger<(Value, Value)>()

        trigger1.bind { value1 in
            if let value2 = trigger2.value {
                trigger.update(withValue: (value1, value2))
            }
        }

        trigger2.bind { value2 in
            if let value1 = trigger1.value {
                trigger.update(withValue: (value1, value2))
            }
        }

        return trigger
    }

    static func combine<A, B>(_ trigger1: Trigger<A>, _ trigger2: Trigger<B>) -> Trigger<(A, B)> {
        let trigger = Trigger<(A, B)>()

        trigger1.bind { value1 in
            if let value2 = trigger2.value {
                trigger.update(withValue: (value1, value2))
            }
        }

        trigger2.bind { value2 in
            if let value1 = trigger1.value {
                trigger.update(withValue: (value1, value2))
            }
        }

        return trigger
    }

    static func merge(_ trigger1: Trigger<Value>, _ trigger2: Trigger<Value>) -> Trigger<Value> {
        let trigger = Trigger<Value>()

        trigger1.bind { value1 in
            trigger.update(withValue: value1)
        }

        trigger2.bind { value2 in
            trigger.update(withValue: value2)
        }

        return trigger
    }

    /**
     `map` performs a transform over a Value and returns it as `TransformedValue` wrapped in its own `Trigger`
     - Parameter transform: The function that transform `Value` into `TransformedValue`
     - Returns: A `Trigger` of type `TransformedValue`
     */
    func map<TransformedValue>(_ transform: @escaping (Value) -> TransformedValue) -> Trigger<TransformedValue> {
        let trigger = Trigger<TransformedValue>()

        bind { value in
            trigger.update(withValue: transform(value))
        }

        return trigger
    }

    /**
     `flatMap` performs a transform over a Value and returns it as `Trigger<TransformedValue>` by flattening
     the nested Triggers
     - Parameter transform: The function that transform `Value` into a new `Trigger` of type `<TransformedValue>`
     - Returns: A flattened `Trigger` of type `TransformedValue`
     */
    func flatMap<TransformedValue>(_ transform: @escaping (Value) -> Trigger<TransformedValue>)
        -> Trigger<TransformedValue> {
        let trigger = Trigger<TransformedValue>()

        bind { value in
            let resultTrigger = transform(value)

            // Bind to the resultTrigger to extract the value so it can 'flatten'
            resultTrigger.bind { value in
                trigger.update(withValue: value)
            }
        }

        return trigger
    }
}

// MARK: - Typed extensions
public extension Trigger where Value == Bool {
    func invert() {
        guard let currentValue = value else {
            return
        }
        update(withValue: !currentValue)
    }
}
