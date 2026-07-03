import CoreGraphics

/// Corner-radius scale used by cards, buttons, banners, and badges.
public struct PKSShapeTokens: Sendable, Equatable {
    public var small: CGFloat
    public var medium: CGFloat
    public var large: CGFloat
    public var pill: CGFloat

    public init(
        small: CGFloat = 8,
        medium: CGFloat = 12,
        large: CGFloat = 16,
        pill: CGFloat = 9999
    ) {
        self.small = small
        self.medium = medium
        self.large = large
        self.pill = pill
    }

    public static let `default` = PKSShapeTokens()
}
