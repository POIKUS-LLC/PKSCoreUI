import Foundation

/// Entry point for configuring PKSCoreUI's shared theme. Call `configure(_:)` once at
/// app launch (typically from `application(_:didFinishLaunchingWithOptions:)`); every
/// shipped component reads `theme` and updates live if you call `configure(_:)` again.
@MainActor
public enum PKSCoreUI {
    /// Configures the shared theme used by every PKSCoreUI component. Safe to call more
    /// than once — components observing theme changes update immediately.
    public static func configure(_ theme: PKSCoreUITheme) {
        PKSCoreUIThemeProvider.shared.configure(theme)
    }

    /// The currently active theme. `.default` until `configure(_:)` is called.
    public static var theme: PKSCoreUITheme {
        PKSCoreUIThemeProvider.shared.theme
    }
}
