import UIKit

/// Semantic color roles, not raw values, so a single accent-color override propagates
/// everywhere. Defaults are all system dynamic colors, so dark mode is automatic —
/// apps only need to override the roles they want to brand (typically `accent`/`onAccent`).
public struct PKSColorTokens: @unchecked Sendable {
    public var accent: UIColor
    public var onAccent: UIColor
    public var background: UIColor
    public var surface: UIColor
    public var surfaceSecondary: UIColor
    public var textPrimary: UIColor
    public var textSecondary: UIColor
    public var separator: UIColor
    public var success: UIColor
    public var warning: UIColor
    public var danger: UIColor
    public var info: UIColor

    public init(
        accent: UIColor = .systemBlue,
        onAccent: UIColor = .white,
        background: UIColor = .systemBackground,
        surface: UIColor = .secondarySystemBackground,
        surfaceSecondary: UIColor = .tertiarySystemBackground,
        textPrimary: UIColor = .label,
        textSecondary: UIColor = .secondaryLabel,
        separator: UIColor = .separator,
        success: UIColor = .systemGreen,
        warning: UIColor = .systemOrange,
        danger: UIColor = .systemRed,
        info: UIColor = .systemBlue
    ) {
        self.accent = accent
        self.onAccent = onAccent
        self.background = background
        self.surface = surface
        self.surfaceSecondary = surfaceSecondary
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.separator = separator
        self.success = success
        self.warning = warning
        self.danger = danger
        self.info = info
    }

    public static let `default` = PKSColorTokens()
}
