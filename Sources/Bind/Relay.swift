import Foundation

public final class Relay: Output<Void> {
  public func fire() {
    update(withValue: ())
  }
}
