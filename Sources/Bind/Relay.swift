public final class Relay: MutableOutput<Void> {
    public func fire() {
        update(withValue: ())
    }
}
