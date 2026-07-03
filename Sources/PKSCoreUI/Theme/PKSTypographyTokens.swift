import UIKit

/// A font paired with the `UIFont.TextStyle` used to scale it for Dynamic Type.
public struct PKSFontToken: @unchecked Sendable {
    public var font: UIFont
    public var textStyle: UIFont.TextStyle

    public init(font: UIFont, textStyle: UIFont.TextStyle) {
        self.font = font
        self.textStyle = textStyle
    }

    /// Dynamic-Type-scaled font for the given trait environment. Apply this instead of
    /// `font` directly so custom brand fonts still respond to the user's text size setting.
    public func scaledFont(compatibleWith traitCollection: UITraitCollection? = nil) -> UIFont {
        UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font, compatibleWith: traitCollection)
    }
}

/// Named type scale. Every role carries its own `UIFont.TextStyle` so Dynamic Type
/// scaling is correct even when an app overrides the underlying font.
public struct PKSTypographyTokens: @unchecked Sendable {
    public var titleLarge: PKSFontToken
    public var title: PKSFontToken
    public var headline: PKSFontToken
    public var body: PKSFontToken
    public var subheadline: PKSFontToken
    public var caption: PKSFontToken
    public var buttonLabel: PKSFontToken

    public init(
        titleLarge: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 28, weight: .bold), textStyle: .largeTitle),
        title: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 22, weight: .semibold), textStyle: .title2),
        headline: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 17, weight: .semibold), textStyle: .headline),
        body: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 17, weight: .regular), textStyle: .body),
        subheadline: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 15, weight: .regular), textStyle: .subheadline),
        caption: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 12, weight: .regular), textStyle: .caption1),
        buttonLabel: PKSFontToken = PKSFontToken(font: .systemFont(ofSize: 17, weight: .semibold), textStyle: .body)
    ) {
        self.titleLarge = titleLarge
        self.title = title
        self.headline = headline
        self.body = body
        self.subheadline = subheadline
        self.caption = caption
        self.buttonLabel = buttonLabel
    }

    public static let `default` = PKSTypographyTokens()
}
