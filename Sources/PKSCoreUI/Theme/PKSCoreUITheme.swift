import Foundation

/// Aggregates every token family a consuming app can customize. Construct with only
/// the overrides you need — every parameter defaults to the system-derived baseline.
///
/// ```swift
/// PKSCoreUI.configure(PKSCoreUITheme(colors: PKSColorTokens(accent: .systemPurple)))
/// ```
public struct PKSCoreUITheme: @unchecked Sendable {
    public var colors: PKSColorTokens
    public var typography: PKSTypographyTokens
    public var spacing: PKSSpacingTokens
    public var shape: PKSShapeTokens
    public var elevation: PKSElevationTokens
    public var motion: PKSMotionTokens
    public var icons: PKSIconProvider

    public init(
        colors: PKSColorTokens = .default,
        typography: PKSTypographyTokens = .default,
        spacing: PKSSpacingTokens = .default,
        shape: PKSShapeTokens = .default,
        elevation: PKSElevationTokens = .default,
        motion: PKSMotionTokens = .default,
        icons: PKSIconProvider = .default
    ) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.shape = shape
        self.elevation = elevation
        self.motion = motion
        self.icons = icons
    }

    public static let `default` = PKSCoreUITheme()
}
