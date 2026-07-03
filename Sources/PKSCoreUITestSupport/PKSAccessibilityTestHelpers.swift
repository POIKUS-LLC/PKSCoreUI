import UIKit
import PKSCoreUI

/// Adds `view` to an offscreen `UIWindow`, forces layout, and returns the window so
/// tests can inspect real (post-layout) frames and accessibility properties. The
/// window keeps `view` alive and in a real window — needed for `didMoveToWindow`
/// behavior, e.g. PKSCoreUI's debug accessibility assertion — without appearing on
/// screen. Callers should retain the returned window for the lifetime of the assertion.
@MainActor
public func pks_makeOffscreenWindow(for view: UIView, size: CGSize = CGSize(width: 375, height: 200)) -> UIWindow {
    let window = UIWindow(frame: CGRect(origin: .zero, size: size))
    view.frame = window.bounds
    window.addSubview(view)
    window.isHidden = false
    view.setNeedsLayout()
    view.layoutIfNeeded()
    return window
}

/// A fake accessibility environment for deterministic Reduce Motion / Reduce
/// Transparency behavior in tests, independent of the test runner's actual system
/// settings. Install via `PKSAccessibility.environment = PKSFakeAccessibilityEnvironment(...)`;
/// restore `PKSAccessibility.environment` to its default in your test's teardown so
/// state doesn't leak across test cases.
public struct PKSFakeAccessibilityEnvironment: PKSAccessibilityEnvironmentProviding {
    public var reduceMotionEnabled: Bool
    public var reduceTransparencyEnabled: Bool

    public init(reduceMotionEnabled: Bool = false, reduceTransparencyEnabled: Bool = false) {
        self.reduceMotionEnabled = reduceMotionEnabled
        self.reduceTransparencyEnabled = reduceTransparencyEnabled
    }

    public func isReduceMotionEnabled() -> Bool { reduceMotionEnabled }
    public func isReduceTransparencyEnabled() -> Bool { reduceTransparencyEnabled }
}
