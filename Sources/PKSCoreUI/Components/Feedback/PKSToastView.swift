import UIKit

/// A transient confirmation view (e.g. "Copied!" after sharing a referral code).
/// Present via `PKSToastPresenter.show(_:in:)` rather than constructing directly.
open class PKSToastView: PKSThemedView {
    private let label = UILabel()

    public init(message: String) {
        super.init(frame: .zero)
        setUp(message: message)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp(message: "")
    }

    private func setUp(message: String) {
        label.text = message
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let horizontal = PKSCoreUI.theme.spacing.md
        let vertical = PKSCoreUI.theme.spacing.sm
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontal),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontal),
            label.topAnchor.constraint(equalTo: topAnchor, constant: vertical),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -vertical),
        ])

        isAccessibilityElement = true
        accessibilityLabel = message
    }

    open override func applyTheme(_ theme: PKSCoreUITheme) {
        backgroundColor = theme.colors.textPrimary
        layer.cornerRadius = theme.shape.medium
        label.font = theme.typography.subheadline.scaledFont(compatibleWith: traitCollection)
        label.textColor = theme.colors.background
    }
}

/// Presents a `PKSToastView` above the bottom safe area of `view`, auto-dismissing
/// after `duration`. Also posts a VoiceOver announcement immediately, since a
/// transient visual-only toast is otherwise easy for VoiceOver users to miss.
@MainActor
public enum PKSToastPresenter {
    public static func show(_ message: String, in view: UIView, duration: TimeInterval = 2.0) {
        let toast = PKSToastView(message: message)
        toast.alpha = 0
        toast.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toast)

        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
        ])

        PKSAccessibility.announce(message)

        PKSAccessibility.animateIfAllowed(duration: PKSCoreUI.theme.motion.standard, animations: {
            toast.alpha = 1
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                MainActor.assumeIsolated {
                    PKSAccessibility.animateIfAllowed(duration: PKSCoreUI.theme.motion.standard, animations: {
                        toast.alpha = 0
                    }, completion: { _ in
                        toast.removeFromSuperview()
                    })
                }
            }
        })
    }
}
