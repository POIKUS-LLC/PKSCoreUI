import UIKit

/// A centered icon/title/message placeholder with an optional action, e.g. "No
/// referrals yet."
open class PKSEmptyStateView: PKSThemedView {
    private let onAction: (() -> Void)?

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var actionButton: PKSButton!
    private let stack = UIStackView()

    public init(
        icon: UIImage? = nil,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        onAction: (() -> Void)? = nil
    ) {
        self.onAction = onAction
        super.init(frame: .zero)
        setUp(icon: icon, title: title, message: message, actionTitle: actionTitle)
    }

    public required init?(coder: NSCoder) {
        self.onAction = nil
        super.init(coder: coder)
        setUp(icon: nil, title: "", message: nil, actionTitle: nil)
    }

    private func setUp(icon: UIImage?, title: String, message: String?, actionTitle: String?) {
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        iconView.isHidden = icon == nil

        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.isHidden = message == nil

        actionButton = PKSButton(style: .secondary, title: actionTitle ?? "")
        actionButton.isHidden = actionTitle == nil
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)

        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = PKSCoreUI.theme.spacing.sm
        stack.translatesAutoresizingMaskIntoConstraints = false
        [iconView, titleLabel, messageLabel, actionButton].forEach(stack.addArrangedSubview)
        addSubview(stack)

        let inset = PKSCoreUI.theme.spacing.lg
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: inset),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: inset),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -inset),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        isAccessibilityElement = true
        accessibilityLabel = [title, message].compactMap { $0 }.joined(separator: ". ")
    }

    @objc private func handleAction() {
        onAction?()
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        iconView.tintColor = theme.colors.textSecondary
        titleLabel.font = theme.typography.headline.scaledFont(compatibleWith: traitCollection)
        titleLabel.textColor = theme.colors.textPrimary
        messageLabel.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        messageLabel.textColor = theme.colors.textSecondary
    }
}
