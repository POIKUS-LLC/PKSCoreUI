import UIKit

/// Base class for every non-interactive visible PKSCoreUI component. Handles theme
/// observation — both explicit `PKSCoreUI.configure(_:)` calls and system trait
/// changes (Dark Mode, Dynamic Type) — through one mechanism, and enforces at
/// `didMoveToWindow` that any view marked as a VoiceOver stop actually has a label.
///
/// Use `PKSAccessibility.animateIfAllowed` for animations so Reduce Motion is honored
/// automatically. See the "Adding a Component" checklist in the README before adding
/// a new subclass.
open class PKSThemedView: UIView {
    private var themeChangeObserver: PKSThemeChangeObserver?
    private var didCheckAccessibilitySetup = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
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

    /// Override to apply theme tokens to this view's subviews/appearance. Called on
    /// init and on every subsequent theme or trait change. The base implementation
    /// does nothing.
    open func applyTheme(_ theme: PKSCoreUITheme) {}

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
}
