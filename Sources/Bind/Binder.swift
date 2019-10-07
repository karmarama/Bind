public struct Binder<Value> {
    private let _binding: (Value) -> Void
    public init<Target: AnyObject>(_ target: Target,
                                   binding: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target
        _binding = { value in
            if let target = weakTarget {
                binding(target, value)
            }
        }
    }
    public func on(_ value: Value) {
        _binding(value)
    }
}

public struct Bindable<TargetType> {
    public let target: TargetType
    public init(_ target: TargetType) {
        self.target = target
    }
}

public protocol BindableCompatible {
    associatedtype CompatibleType
    var binding: Bindable<CompatibleType> { get }
}

public extension BindableCompatible {
    var binding: Bindable<Self> {
        return Bindable(self)
    }
}

public protocol Unbindable: AnyObject {
    func unbind(for subscription: Subscription)
}
