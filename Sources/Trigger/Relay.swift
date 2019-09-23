import Foundation

final class Relay: Trigger<Void> {
    func fire() {
        update(withValue: ())
    }
}
