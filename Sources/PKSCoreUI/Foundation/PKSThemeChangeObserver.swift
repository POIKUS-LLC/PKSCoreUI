import Foundation

/// Observes PKSCoreUI theme changes and forwards them to a closure. Composition-based
/// so components that must subclass a specific UIKit type (e.g. `PKSButton: UIButton`)
/// can react to `PKSCoreUI.configure(_:)` without going through
/// `PKSThemedView`/`PKSThemedControl`.
final class PKSThemeChangeObserver {
    private var token: NSObjectProtocol?

    init(onChange: @escaping @MainActor () -> Void) {
        token = NotificationCenter.default.addObserver(
            forName: .pksCoreUIThemeDidChange,
            object: nil,
            queue: .main
        ) { _ in
            MainActor.assumeIsolated {
                onChange()
            }
        }
    }

    deinit {
        if let token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
