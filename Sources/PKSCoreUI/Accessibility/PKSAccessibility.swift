import UIKit

/// Accessibility helpers shared across every component so behavior (tap targets,
/// reduced motion, VoiceOver announcements) is centralized instead of re-implemented
/// per component.
@MainActor
public enum PKSAccessibility {
    /// Apple HIG minimum tappable area.
    public static let minimumTapTargetSize = CGSize(width: 44, height: 44)

    /// Wraps `UIAccessibility.isReduceMotionEnabled`. Injectable via `environment` so
    /// tests get deterministic behavior instead of depending on the test runner's
    /// actual system setting.
    public static var prefersReducedMotion: Bool {
        environment.isReduceMotionEnabled()
    }

    /// Wraps `UIAccessibility.isReduceTransparencyEnabled`.
    public static var prefersReducedTransparency: Bool {
        environment.isReduceTransparencyEnabled()
    }

    /// True for the larger "accessibility" content size categories (AX1–AX5), at which
    /// point components should switch from horizontal to vertical layout.
    public static func isAccessibilityCategory(_ category: UIContentSizeCategory) -> Bool {
        category.isAccessibilityCategory
    }

    /// Posts a VoiceOver announcement, e.g. after a toast appears or an async action completes.
    public static func announce(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    /// The only sanctioned animation entry point in PKSCoreUI — honors Reduce Motion by
    /// collapsing to a zero-duration animation (so the end state and completion handler
    /// still fire) instead of components remembering to check the flag individually.
    public static func animateIfAllowed(
        duration: TimeInterval,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        let effectiveDuration = prefersReducedMotion ? 0 : duration
        UIView.animate(withDuration: effectiveDuration, delay: delay, options: options, animations: animations, completion: completion)
    }

    /// Test seam: `PKSCoreUITestSupport` swaps this for a fake so Reduce Motion /
    /// Reduce Transparency behavior is deterministic in tests.
    public static var environment: any PKSAccessibilityEnvironmentProviding = PKSSystemAccessibilityEnvironment()
}

/// Abstracts the system accessibility flags PKSCoreUI reads, so tests can inject
/// deterministic values instead of depending on the real (test-runner) UIAccessibility state.
public protocol PKSAccessibilityEnvironmentProviding {
    func isReduceMotionEnabled() -> Bool
    func isReduceTransparencyEnabled() -> Bool
}

struct PKSSystemAccessibilityEnvironment: PKSAccessibilityEnvironmentProviding {
    func isReduceMotionEnabled() -> Bool { UIAccessibility.isReduceMotionEnabled }
    func isReduceTransparencyEnabled() -> Bool { UIAccessibility.isReduceTransparencyEnabled }
}
