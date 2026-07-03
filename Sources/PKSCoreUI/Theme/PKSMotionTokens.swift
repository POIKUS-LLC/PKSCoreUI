import Foundation

/// Animation durations. Components must consult `PKSAccessibility.prefersReducedMotion`
/// (via `PKSThemedView.animateIfAllowed`) before using these — see Accessibility/PKSAccessibility.swift.
public struct PKSMotionTokens: Sendable, Equatable {
    public var fast: TimeInterval
    public var standard: TimeInterval
    public var slow: TimeInterval

    public init(
        fast: TimeInterval = 0.15,
        standard: TimeInterval = 0.25,
        slow: TimeInterval = 0.4
    ) {
        self.fast = fast
        self.standard = standard
        self.slow = slow
    }

    public static let `default` = PKSMotionTokens()
}
