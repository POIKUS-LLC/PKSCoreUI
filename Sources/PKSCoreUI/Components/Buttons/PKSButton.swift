import UIKit

/// A themed button with four sanctioned styles. Subclasses `UIButton` directly (not
/// `PKSThemedControl`) to keep `UIButton.Configuration`'s built-in title/image/state
/// management and default VoiceOver behavior; theme observation is composed via
/// `PKSThemeChangeObserver` instead.
open class PKSButton: UIButton {
    public enum Style: Sendable {
        case primary
        case secondary
        case tertiary
        case destructive
    }

    public let style: Style
    private var themeChangeObserver: PKSThemeChangeObserver?
    private var didCheckAccessibilitySetup = false

    public init(style: Style, title: String, image: UIImage? = nil) {
        self.style = style
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = image
        config.imagePadding = 8
        configuration = config
        commonInit()
    }

    public required init?(coder: NSCoder) {
        self.style = .primary
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        accessibilityTraits.insert(.button)
        themeChangeObserver = PKSThemeChangeObserver { [weak self] in
            self?.applyTheme(PKSCoreUI.theme)
        }
        applyTheme(PKSCoreUI.theme)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
            || traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory
        else { return }
        applyTheme(PKSCoreUI.theme)
    }

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        #if DEBUG
        assertAccessibilitySetupIfNeeded()
        #endif
    }

    #if DEBUG
    private func assertAccessibilitySetupIfNeeded() {
        guard window != nil, !didCheckAccessibilitySetup else { return }
        didCheckAccessibilitySetup = true
        if isAccessibilityElement && (accessibilityLabel?.isEmpty ?? true) {
            assertionFailure(
                "\(type(of: self)) is marked isAccessibilityElement but has no accessibilityLabel set."
            )
        }
    }
    #endif

    /// Expands the effective hit area to Apple's 44x44pt HIG minimum, regardless of
    /// the button's visual (bounds) size.
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let minSize = PKSAccessibility.minimumTapTargetSize
        let dx = max((minSize.width - bounds.width) / 2, 0)
        let dy = max((minSize.height - bounds.height) / 2, 0)
        let hitFrame = bounds.insetBy(dx: -dx, dy: -dy)
        return hitFrame.contains(point)
    }

    private func applyTheme(_ theme: PKSCoreUITheme) {
        guard var config = configuration else { return }

        config.cornerStyle = .fixed
        config.background.cornerRadius = theme.shape.medium

        let font = theme.typography.buttonLabel.scaledFont(compatibleWith: traitCollection)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }

        switch style {
        case .primary:
            config.baseForegroundColor = theme.colors.onAccent
            config.background.backgroundColor = theme.colors.accent
        case .secondary:
            config.baseForegroundColor = theme.colors.accent
            config.background.backgroundColor = theme.colors.surface
        case .tertiary:
            config.baseForegroundColor = theme.colors.accent
            config.background.backgroundColor = .clear
        case .destructive:
            config.baseForegroundColor = theme.colors.onAccent
            config.background.backgroundColor = theme.colors.danger
        }

        configuration = config
    }
}
