import UIKit

/// A centered error placeholder with a retry action, used as the error state for
/// `PKSStatefulViewController`-based screens (e.g. surfacing a `ReferralError`).
open class PKSErrorStateView: PKSThemedView {
    private let onRetry: () -> Void

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var retryButton: PKSButton!
    private let stack = UIStackView()

    public init(
        title: String = "Something went wrong",
        message: String? = nil,
        retryTitle: String = "Try Again",
        onRetry: @escaping () -> Void
    ) {
        self.onRetry = onRetry
        super.init(frame: .zero)
        setUp(title: title, message: message, retryTitle: retryTitle)
    }

    public required init?(coder: NSCoder) {
        self.onRetry = {}
        super.init(coder: coder)
        setUp(title: "Something went wrong", message: nil, retryTitle: "Try Again")
    }

    private func setUp(title: String, message: String?, retryTitle: String) {
        iconView.image = PKSCoreUI.theme.icons.danger
        iconView.contentMode = .scaleAspectFit

        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.isHidden = message == nil

        retryButton = PKSButton(style: .primary, title: retryTitle)
        retryButton.addTarget(self, action: #selector(handleRetry), for: .touchUpInside)

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = PKSCoreUI.theme.spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        [iconView, titleLabel, messageLabel, retryButton].forEach(stack.addArrangedSubview)
        addSubview(stack)

        let inset = PKSCoreUI.theme.spacing.lg
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        isAccessibilityElement = true
        accessibilityLabel = [title, message].compactMap { $0 }.joined(separator: ". ")
    }

    @objc private func handleRetry() {
        onRetry()
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        iconView.tintColor = theme.colors.danger
        titleLabel.font = theme.typography.headline.scaledFont(compatibleWith: traitCollection)
        titleLabel.textColor = theme.colors.textPrimary
        messageLabel.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        messageLabel.textColor = theme.colors.textSecondary
    }
}
