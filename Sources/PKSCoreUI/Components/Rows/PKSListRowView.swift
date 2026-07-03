import UIKit

/// A leading-icon / title+subtitle / trailing-accessory row, usable standalone (e.g.
/// in a `UIStackView`) or embedded in `PKSListRowCell` for `UITableView`.
open class PKSListRowView: PKSThemedView {
    public enum AccessoryStyle: Sendable {
        case none
        case disclosure
        case text(String)
    }

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let accessoryLabel = UILabel()
    private let disclosureView = UIImageView()
    private let textStack = UIStackView()
    private let rowStack = UIStackView()

    public init() {
        super.init(frame: .zero)
        setUp()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontForContentSizeCategory = true

        subtitleLabel.numberOfLines = 0
        subtitleLabel.adjustsFontForContentSizeCategory = true

        accessoryLabel.adjustsFontForContentSizeCategory = true
        accessoryLabel.setContentHuggingPriority(.required, for: .horizontal)

        disclosureView.contentMode = .scaleAspectFit
        disclosureView.setContentHuggingPriority(.required, for: .horizontal)

        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)

        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.spacing = PKSCoreUI.theme.spacing.sm
        rowStack.translatesAutoresizingMaskIntoConstraints = false
        rowStack.addArrangedSubview(iconView)
        rowStack.addArrangedSubview(textStack)
        rowStack.addArrangedSubview(accessoryLabel)
        rowStack.addArrangedSubview(disclosureView)
        addSubview(rowStack)

        let horizontalInset = PKSCoreUI.theme.spacing.md
        let verticalInset = PKSCoreUI.theme.spacing.sm
        NSLayoutConstraint.activate([
            rowStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalInset),
            rowStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalInset),
            rowStack.topAnchor.constraint(equalTo: topAnchor, constant: verticalInset),
            rowStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalInset),
        ])

        isAccessibilityElement = true
        configure(title: "")
    }

    public func configure(icon: UIImage? = nil, title: String, subtitle: String? = nil, accessory: AccessoryStyle = .none) {
        iconView.image = icon
        iconView.isHidden = icon == nil
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle == nil

        switch accessory {
        case .none:
            accessoryLabel.isHidden = true
            disclosureView.isHidden = true
        case .disclosure:
            accessoryLabel.isHidden = true
            disclosureView.isHidden = false
            disclosureView.image = UIImage(systemName: "chevron.forward")
        case .text(let text):
            accessoryLabel.isHidden = false
            accessoryLabel.text = text
            disclosureView.isHidden = true
        }

        accessibilityLabel = [title, subtitle, accessoryText(for: accessory)].compactMap { $0 }.joined(separator: ", ")
    }

    private func accessoryText(for accessory: AccessoryStyle) -> String? {
        if case let .text(text) = accessory { return text }
        return nil
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        backgroundColor = .clear
        titleLabel.font = theme.typography.body.scaledFont(compatibleWith: traitCollection)
        titleLabel.textColor = theme.colors.textPrimary
        subtitleLabel.font = theme.typography.caption.scaledFont(compatibleWith: traitCollection)
        subtitleLabel.textColor = theme.colors.textSecondary
        accessoryLabel.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        accessoryLabel.textColor = theme.colors.textSecondary
        disclosureView.tintColor = theme.colors.textSecondary
        iconView.tintColor = theme.colors.accent
    }
}
