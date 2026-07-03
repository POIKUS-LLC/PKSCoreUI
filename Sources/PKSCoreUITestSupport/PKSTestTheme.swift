import UIKit
import PKSCoreUI

/// A deterministic, non-dynamic theme fixture for tests — fixed colors regardless of
/// trait environment, so assertions don't depend on light/dark mode or system settings.
public enum PKSTestTheme {
    public static let theme = PKSCoreUITheme(
        colors: PKSColorTokens(
            accent: UIColor(red: 0.20, green: 0.40, blue: 0.90, alpha: 1),
            onAccent: .white,
            background: .white,
            surface: UIColor(white: 0.95, alpha: 1),
            surfaceSecondary: UIColor(white: 0.90, alpha: 1),
            textPrimary: .black,
            textSecondary: UIColor(white: 0.40, alpha: 1),
            separator: UIColor(white: 0.80, alpha: 1),
            success: UIColor(red: 0.20, green: 0.70, blue: 0.30, alpha: 1),
            warning: UIColor(red: 0.90, green: 0.60, blue: 0.10, alpha: 1),
            danger: UIColor(red: 0.80, green: 0.20, blue: 0.20, alpha: 1),
            info: UIColor(red: 0.20, green: 0.50, blue: 0.90, alpha: 1)
        )
    )
}
