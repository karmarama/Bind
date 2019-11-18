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
