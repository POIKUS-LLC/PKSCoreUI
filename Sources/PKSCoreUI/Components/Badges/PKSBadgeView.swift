import UIKit

/// A pill-shaped status badge. Backend status fields consumed by referral screens
/// (e.g. `ReferralCode.status`, `RevenueRow.eventType`) are raw, backend-controlled
/// strings, not closed Swift enums — so `PKSBadgeView` takes an already-resolved
/// `Style`, and it's the caller's responsibility to map their status string to one
/// (typically in the downstream feature package, not here, since PKSCoreUI has no
/// knowledge of any particular backend's status vocabulary).
open class PKSBadgeView: PKSThemedView {
    public enum Style: Sendable {
        case neutral
        case accent
        case success
        case warning
        case danger
        case info
    }

    private let label = UILabel()
    private var style: Style

    public init(text: String, style: Style = .neutral) {
        self.style = style
        super.init(frame: .zero)
        setUp()
        update(text: text, style: style)
    }

    public required init?(coder: NSCoder) {
        self.style = .neutral
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let horizontal = PKSCoreUI.theme.spacing.sm
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontal),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontal),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
        ])

        isAccessibilityElement = true
    }

    /// Updates the badge's text and style.
    public func update(text: String, style: Style) {
        self.style = style
        label.text = text
        accessibilityLabel = text
        applyTheme(PKSCoreUI.theme)
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        label.font = theme.typography.caption.scaledFont(compatibleWith: traitCollection)
        let (background, foreground) = colors(for: style, theme: theme)
        backgroundColor = background
        label.textColor = foreground
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    private func colors(for style: Style, theme: PKSCoreUITheme) -> (UIColor, UIColor) {
        switch style {
        case .neutral: return (theme.colors.surfaceSecondary, theme.colors.textSecondary)
        case .accent: return (theme.colors.accent.withAlphaComponent(0.15), theme.colors.accent)
        case .success: return (theme.colors.success.withAlphaComponent(0.15), theme.colors.success)
        case .warning: return (theme.colors.warning.withAlphaComponent(0.15), theme.colors.warning)
        case .danger: return (theme.colors.danger.withAlphaComponent(0.15), theme.colors.danger)
        case .info: return (theme.colors.info.withAlphaComponent(0.15), theme.colors.info)
        }
    }
}
