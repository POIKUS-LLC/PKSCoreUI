import Foundation

extension Notification.Name {
    /// Posted after `PKSCoreUI.configure(_:)` updates the active theme. `PKSThemedView`
    /// and `PKSThemedControl` observe this to live-update already-rendered components.
    static let pksCoreUIThemeDidChange = Notification.Name("PKSCoreUI.themeDidChange")
}

/// Backing store for `PKSCoreUI.theme`/`configure(_:)`. `UIView`/`UIControl` are
/// effectively main-actor-bound in UIKit, so a `@MainActor` singleton satisfies Swift 6
/// strict concurrency without locks — every consumer of this theme already runs on the
/// main actor by construction.
@MainActor
final class PKSCoreUIThemeProvider {
    static let shared = PKSCoreUIThemeProvider()

    private(set) var theme: PKSCoreUITheme = .default

    private init() {}

    func configure(_ theme: PKSCoreUITheme) {
        self.theme = theme
        NotificationCenter.default.post(name: .pksCoreUIThemeDidChange, object: nil)
    }
}
