import UIKit

/// WCAG 2.x contrast-ratio math. Pure and deterministic — no view/trait side effects
/// beyond resolving a color for a given appearance — so it's fully unit-testable and
/// backs `PKSColorTokenContrastTests`.
public enum PKSContrastValidator {
    /// Relative luminance per WCAG 2.x, resolving the color against `traitCollection`
    /// first since system/dynamic colors otherwise resolve ambiguously.
    public static func relativeLuminance(
        of color: UIColor,
        traitCollection: UITraitCollection = UITraitCollection(userInterfaceStyle: .light)
    ) -> Double {
        let resolved = color.resolvedColor(with: traitCollection)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        resolved.getRed(&r, green: &g, blue: &b, alpha: &a)

        func channel(_ value: CGFloat) -> Double {
            let value = Double(value)
            return value <= 0.03928 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }

        return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
    }

    /// Contrast ratio between two colors: 1 (no contrast) to 21 (max contrast).
    public static func contrastRatio(
        _ first: UIColor,
        _ second: UIColor,
        traitCollection: UITraitCollection = UITraitCollection(userInterfaceStyle: .light)
    ) -> Double {
        let l1 = relativeLuminance(of: first, traitCollection: traitCollection)
        let l2 = relativeLuminance(of: second, traitCollection: traitCollection)
        let lighter = max(l1, l2)
        let darker = min(l1, l2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    /// WCAG AA threshold: 4.5:1 for normal text, 3:1 for large text (≥18pt, or ≥14pt bold).
    public static func meetsWCAGAA(
        foreground: UIColor,
        background: UIColor,
        isLargeText: Bool = false,
        traitCollection: UITraitCollection = UITraitCollection(userInterfaceStyle: .light)
    ) -> Bool {
        contrastRatio(foreground, background, traitCollection: traitCollection) >= (isLargeText ? 3.0 : 4.5)
    }
}
