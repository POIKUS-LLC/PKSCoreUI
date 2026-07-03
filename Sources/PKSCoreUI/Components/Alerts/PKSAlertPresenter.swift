import UIKit

/// A single alert action for `PKSAlertPresenter`.
public struct PKSAlertAction: Sendable {
    public enum Style: Sendable {
        case `default`
        case cancel
        case destructive
    }

    public let title: String
    public let style: Style
    public let handler: (@MainActor () -> Void)?

    public init(title: String, style: Style = .default, handler: (@MainActor () -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

/// Thin wrapper over `UIAlertController` so callers don't hand-roll `UIAlertAction`
/// boilerplate. This is the core interaction behind the guest-linking prompt future
/// screen, and is also useful for generic confirmations elsewhere.
@MainActor
public enum PKSAlertPresenter {
    public static func present(
        title: String?,
        message: String?,
        actions: [PKSAlertAction],
        from viewController: UIViewController
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = PKSCoreUI.theme.colors.accent

        for action in actions {
            let uiStyle: UIAlertAction.Style
            switch action.style {
            case .default: uiStyle = .default
            case .cancel: uiStyle = .cancel
            case .destructive: uiStyle = .destructive
            }
            alert.addAction(UIAlertAction(title: action.title, style: uiStyle) { _ in
                MainActor.assumeIsolated {
                    action.handler?()
                }
            })
        }

        viewController.present(alert, animated: true)
    }
}
