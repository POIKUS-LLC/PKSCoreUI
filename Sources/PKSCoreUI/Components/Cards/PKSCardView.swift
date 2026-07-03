import UIKit

/// A themed container surface with elevation and rounded corners. Add subviews to
/// `contentView`, not the card itself, so padding stays consistent with the theme.
open class PKSCardView: PKSThemedView {
    public let contentView = UIView()
    private let padding: CGFloat

    public init(padding: CGFloat? = nil) {
        self.padding = padding ?? PKSCoreUI.theme.spacing.md
        super.init(frame: .zero)
        setUpContentView()
    }

    public required init?(coder: NSCoder) {
        self.padding = PKSCoreUI.theme.spacing.md
        super.init(coder: coder)
        setUpContentView()
    }

    private func setUpContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ])
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        backgroundColor = theme.colors.surface
        layer.cornerRadius = theme.shape.large
        theme.elevation.apply(to: layer)
    }
}
