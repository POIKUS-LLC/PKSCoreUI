import UIKit

/// Thin wrapper over `UIActivityViewController` that centralizes iPad popover-source
/// handling (a crash on iPad if omitted) so every call site doesn't need to remember
/// it. This is the "Share" action behind the Invite & Share future screen.
@MainActor
public enum PKSActivityShareController {
    public static func present(
        items: [Any],
        excludedActivityTypes: [UIActivity.ActivityType]? = nil,
        from viewController: UIViewController,
        sourceView: UIView,
        sourceRect: CGRect? = nil,
        completion: (@MainActor (Bool) -> Void)? = nil
    ) {
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = excludedActivityTypes
        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            MainActor.assumeIsolated {
                completion?(completed)
            }
        }

        if let popover = activityViewController.popoverPresentationController {
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect ?? sourceView.bounds
        }

        viewController.present(activityViewController, animated: true)
    }
}
