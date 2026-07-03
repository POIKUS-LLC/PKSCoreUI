import UIKit

/// `UITableViewCell` wrapper around `PKSListRowView` for use in `UITableView`-based
/// screens (e.g. a Referral Dashboard's revenue/history rows).
open class PKSListRowCell: UITableViewCell {
    public static let reuseIdentifier = "PKSListRowCell"

    private let rowView = PKSListRowView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private func setUp() {
        selectionStyle = .default
        rowView.translatesAutoresizingMaskIntoConstraints = false
        rowView.isAccessibilityElement = false // the cell itself is the single VoiceOver stop
        rowView.isUserInteractionEnabled = false
        contentView.addSubview(rowView)
        NSLayoutConstraint.activate([
            rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    public func configure(
        icon: UIImage? = nil,
        title: String,
        subtitle: String? = nil,
        accessory: PKSListRowView.AccessoryStyle = .none
    ) {
        rowView.configure(icon: icon, title: title, subtitle: subtitle, accessory: accessory)
        accessibilityLabel = rowView.accessibilityLabel
    }
}
