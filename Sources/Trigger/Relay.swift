import Foundation

public final class Relay: Trigger<Void> {
    func fire() {
        update(withValue: ())
    }
}
