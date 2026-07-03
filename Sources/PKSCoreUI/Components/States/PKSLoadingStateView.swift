import UIKit

/// A centered spinner with an optional message, used as the loading state for
/// `PKSStatefulViewController`-based screens.
open class PKSLoadingStateView: PKSThemedView {
    private let spinner = UIActivityIndicatorView(style: .medium)
    private let label = UILabel()
    private let stack = UIStackView()

    public init(message: String? = nil) {
        super.init(frame: .zero)
        setUp(message: message)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp(message: nil)
    }

    private func setUp(message: String?) {
        spinner.startAnimating()
        spinner.hidesWhenStopped = true

        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.isHidden = message == nil

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = PKSCoreUI.theme.spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(spinner)
        stack.addArrangedSubview(label)
        addSubview(stack)

        let inset = PKSCoreUI.theme.spacing.lg
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
        ])

        isAccessibilityElement = true
        accessibilityLabel = message ?? "Loading"
        accessibilityTraits = .updatesFrequently
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        spinner.color = theme.colors.accent
        label.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        label.textColor = theme.colors.textSecondary
    }
}
