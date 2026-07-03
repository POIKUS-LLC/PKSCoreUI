import CoreGraphics

/// A small spacing scale used for padding, stack spacing, and layout gaps.
public struct PKSSpacingTokens: Sendable, Equatable {
    public var xs: CGFloat
    public var sm: CGFloat
    public var md: CGFloat
    public var lg: CGFloat
    public var xl: CGFloat

    public init(
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }

    public static let `default` = PKSSpacingTokens()
}
