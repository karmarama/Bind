import Foundation

// MARK: - Core
public class Output<Value>: Unbindable {
  public struct Printer: Printable {
    public init() {}
    public func print(_ value: String) {
      Swift.print(value)
    }
  }
  
  private var observers = [Subscription: ((Value) -> Void)]()
  private var value: Value?
  private var debugIdentifier: String?
  private let printer: Printable
  
  public init(value: Value? = nil, printer: Printable = Printer()) {
    self.value = value
    self.printer = printer
  }
  
  public func update(withValue value: Value) {
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
  
  @discardableResult public func bind(to binder: Binder<Value>) -> Subscription {
    return bind(binder.on)
  }
  
  public func bind(to binders: [Binder<Value>]) {
    for binder in binders {
      bind(binder.on)
    }
  }
  
  @discardableResult public func bind(_ closure: @escaping (Value) -> Void) -> Subscription {
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
  static func combine(_ output1: Output<Value>, _ output2: Output<Value>) -> Output<(Value, Value)> {
    let output = Output<(Value, Value)>()
    
    output1.bind { value1 in
      if let value2 = output2.value {
        output.update(withValue: (value1, value2))
      }
    }
    
    output2.bind { value2 in
      if let value1 = output1.value {
        output.update(withValue: (value1, value2))
      }
    }
    
    return output
  }
  
  static func combine<A, B>(_ output1: Output<A>, _ output2: Output<B>) -> Output<(A, B)> {
    let output = Output<(A, B)>()
    
    output1.bind { value1 in
      if let value2 = output2.value {
        output.update(withValue: (value1, value2))
      }
    }
    
    output2.bind { value2 in
      if let value1 = output1.value {
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
}

// MARK: - Typed extensions
public extension Output where Value == Bool {
  func invert() {
    guard let currentValue = value else {
      return
    }
    update(withValue: !currentValue)
  }
}
