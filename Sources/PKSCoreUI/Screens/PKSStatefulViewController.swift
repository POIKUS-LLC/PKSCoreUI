import UIKit

/// Screen shell that composes loading/content/empty/error states behind one `state`
/// property, so screens don't hand-roll state-view swapping individually. Subclasses
/// install their real content into `contentContainer` and can override the `*View()`
/// factory methods to customize copy/icons; sensible defaults are provided.
open class PKSStatefulViewController: UIViewController {
    public let contentContainer = UIView()

    public var state: PKSContentState = .content {
        didSet {
            guard isViewLoaded else { return }
            updateStateView()
        }
    }

    /// Invoked when the user taps the empty state's action button, if one is shown.
    public var onEmptyAction: (() -> Void)?
    /// Invoked when the user taps the error state's retry button.
    public var onRetry: (() -> Void)?

    private var stateView: UIView?

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PKSCoreUI.theme.colors.background

        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        updateStateView()
    }

    /// Override to customize the loading view. Defaults to `PKSLoadingStateView`.
    open func loadingView(message: String?) -> UIView {
        PKSLoadingStateView(message: message)
    }

    /// Override to customize the empty-state view. Defaults to `PKSEmptyStateView`.
    open func emptyView(title: String, message: String?, actionTitle: String?) -> UIView {
        PKSEmptyStateView(title: title, message: message, actionTitle: actionTitle) { [weak self] in
            self?.onEmptyAction?()
        }
    }

    /// Override to customize the error view. Defaults to `PKSErrorStateView`.
    open func errorView(title: String, message: String?, retryTitle: String) -> UIView {
        PKSErrorStateView(title: title, message: message, retryTitle: retryTitle) { [weak self] in
            self?.onRetry?()
        }
    }

    private func updateStateView() {
        stateView?.removeFromSuperview()
        stateView = nil

        let newStateView: UIView?
        switch state {
        case .content:
            newStateView = nil
        case .loading(let message):
            newStateView = loadingView(message: message)
        case .empty(let title, let message, let actionTitle):
            newStateView = emptyView(title: title, message: message, actionTitle: actionTitle)
        case .error(let title, let message, let retryTitle):
            newStateView = errorView(title: title, message: message, retryTitle: retryTitle)
        }

        contentContainer.isHidden = newStateView != nil
        guard let newStateView else { return }

        newStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newStateView)
        NSLayoutConstraint.activate([
            newStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newStateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        stateView = newStateView
    }
}
