import Foundation

public final class Relay: Trigger<Void> {
  public func fire() {
    update(withValue: ())
  }
}
