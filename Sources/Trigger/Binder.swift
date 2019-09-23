import Foundation

struct Binder<Value> {
    private let _binding: (Value) -> Void
    init<Target: AnyObject>(_ target: Target,
                            binding: @escaping (Target, Value) -> Void) {
        weak var weakTarget = target
        _binding = { value in
            if let target = weakTarget {
                binding(target, value)
            }
        }
    }
    func on(_ value: Value) {
        _binding(value)
    }
}

struct Bindable<TargetType> {
    let target: TargetType
    init(_ target: TargetType) {
        self.target = target
    }
}

protocol BindableCompatible {
    associatedtype CompatibleType
    var binding: Bindable<CompatibleType> { get }
}

extension BindableCompatible {
    var binding: Bindable<Self> {
        return Bindable(self)
    }
}

protocol Unbindable: AnyObject {
    func unbind(for subscription: Subscription)
}
