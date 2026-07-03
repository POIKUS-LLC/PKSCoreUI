import UIKit

/// A single elevation/shadow definition. v1 ships one level, applied to surfaces
/// like `PKSCardView`; add named levels here if a future screen needs visual layering.
public struct PKSElevationTokens: @unchecked Sendable {
    public var color: UIColor
    public var opacity: Float
    public var radius: CGFloat
    public var offset: CGSize

    public init(
        color: UIColor = .black,
        opacity: Float = 0.12,
        radius: CGFloat = 8,
        offset: CGSize = CGSize(width: 0, height: 2)
    ) {
        self.color = color
        self.opacity = opacity
        self.radius = radius
        self.offset = offset
    }

    public static let `default` = PKSElevationTokens()

    public func apply(to layer: CALayer) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
