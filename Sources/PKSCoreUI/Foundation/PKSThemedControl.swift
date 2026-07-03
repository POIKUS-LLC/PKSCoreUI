import UIKit

/// Base class for every interactive PKSCoreUI component (buttons, etc). Duplicates
/// `PKSThemedView`'s theme-observation and accessibility-assertion behavior — `UIControl`
/// and `UIView` can't share a common non-UIKit superclass, so this is deliberate
/// duplication rather than a shared mixin. Additionally enforces a minimum tap target.
open class PKSThemedControl: UIControl {
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

    /// Override to apply theme tokens. Called on init and on every subsequent theme or
    /// trait change. The base implementation does nothing.
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

    /// Expands the effective hit area to Apple's 44x44pt HIG minimum regardless of the
    /// control's visual (bounds) size, so a compact visual design never shrinks the
    /// actual tappable area below the accessible minimum.
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let minSize = PKSAccessibility.minimumTapTargetSize
        let dx = max((minSize.width - bounds.width) / 2, 0)
        let dy = max((minSize.height - bounds.height) / 2, 0)
        let hitFrame = bounds.insetBy(dx: -dx, dy: -dy)
        return hitFrame.contains(point)
    }
}
