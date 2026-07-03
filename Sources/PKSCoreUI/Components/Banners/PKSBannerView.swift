import UIKit

/// An icon/title/message banner with an optional action and dismiss button. This
/// component **is** the "embeddable invite-a-friend banner" a host app drops into an
/// existing screen; it's also reusable for generic inline feedback.
open class PKSBannerView: PKSThemedView {
    public enum Style: Sendable {
        case accent
        case info
        case success
        case warning
        case danger
    }

    private let style: Style
    private let onAction: (() -> Void)?
    private let onDismiss: (() -> Void)?

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private var actionButton: PKSButton!
    private let dismissButton = UIButton(type: .system)
    private let textStack = UIStackView()
    private let contentStack = UIStackView()

    public init(
        style: Style,
        icon: UIImage? = nil,
        title: String,
        message: String? = nil,
        actionTitle: String? = nil,
        isDismissable: Bool = false,
        onAction: (() -> Void)? = nil,
        onDismiss: (() -> Void)? = nil
    ) {
        self.style = style
        self.onAction = onAction
        self.onDismiss = onDismiss
        super.init(frame: .zero)
        setUp(icon: icon, title: title, message: message, actionTitle: actionTitle, isDismissable: isDismissable)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("PKSBannerView does not support Interface Builder")
    }

    private func setUp(icon: UIImage?, title: String, message: String?, actionTitle: String?, isDismissable: Bool) {
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.isHidden = icon == nil
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.isHidden = message == nil

        actionButton = PKSButton(style: .tertiary, title: actionTitle ?? "")
        actionButton.isHidden = actionTitle == nil
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)

        dismissButton.setImage(PKSCoreUI.theme.icons.dismiss, for: .normal)
        dismissButton.isAccessibilityElement = false
        dismissButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        dismissButton.isHidden = !isDismissable

        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(messageLabel)
        textStack.addArrangedSubview(actionButton)

        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.spacing = PKSCoreUI.theme.spacing.sm
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(iconView)
        contentStack.addArrangedSubview(textStack)
        contentStack.addArrangedSubview(dismissButton)
        addSubview(contentStack)

        let inset = PKSCoreUI.theme.spacing.md
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])

        isAccessibilityElement = true
        accessibilityLabel = [title, message].compactMap { $0 }.joined(separator: ". ")
        updateAccessibilityCustomActions(actionTitle: actionTitle, isDismissable: isDismissable)
        updateAxis(for: traitCollection)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateAxis(for: traitCollection)
    }

    private func updateAxis(for traitCollection: UITraitCollection) {
        contentStack.axis = PKSAccessibility.isAccessibilityCategory(traitCollection.preferredContentSizeCategory) ? .vertical : .horizontal
    }

    private func updateAccessibilityCustomActions(actionTitle: String?, isDismissable: Bool) {
        var actions: [UIAccessibilityCustomAction] = []
        if let actionTitle {
            actions.append(UIAccessibilityCustomAction(name: actionTitle) { [weak self] _ in
                self?.handleAction()
                return true
            })
        }
        if isDismissable {
            actions.append(UIAccessibilityCustomAction(name: "Dismiss") { [weak self] _ in
                self?.handleDismiss()
                return true
            })
        }
        accessibilityCustomActions = actions
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        layer.cornerRadius = theme.shape.medium
        titleLabel.font = theme.typography.headline.scaledFont(compatibleWith: traitCollection)
        titleLabel.textColor = theme.colors.textPrimary
        messageLabel.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        messageLabel.textColor = theme.colors.textSecondary
        dismissButton.tintColor = theme.colors.textSecondary

        let tint: UIColor
        switch style {
        case .accent: tint = theme.colors.accent
        case .info: tint = theme.colors.info
        case .success: tint = theme.colors.success
        case .warning: tint = theme.colors.warning
        case .danger: tint = theme.colors.danger
        }
        backgroundColor = tint.withAlphaComponent(0.12)
        iconView.tintColor = tint
    }

    @objc private func handleAction() {
        onAction?()
    }

    @objc private func handleDismiss() {
        onDismiss?()
    }
}
