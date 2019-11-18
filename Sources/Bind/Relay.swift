/// A concrete subclass of Output that purely emits values as it receives them but
/// does not replay them on future subscribtion events
public final class Relay<Value>: Output<Value> {
    public override func update(withValue value: Value) {
        super.update(withValue: value)
        self.value = nil
    }
}

public extension Relay where Value == Void {
    func fire() {
        update(withValue: ())
    }
}
