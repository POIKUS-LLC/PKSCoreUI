import UIKit
import Testing
@testable import PKSCoreUI

@Suite struct PKSColorTokenContrastTests {
    private static let lightTrait = UITraitCollection(userInterfaceStyle: .light)
    private static let darkTrait = UITraitCollection(userInterfaceStyle: .dark)

    @Test func primaryTextOnBackgroundMeetsAA() {
        let colors = PKSColorTokens.default
        for trait in [Self.lightTrait, Self.darkTrait] {
            #expect(PKSContrastValidator.meetsWCAGAA(
                foreground: colors.textPrimary, background: colors.background, traitCollection: trait
            ))
        }
    }

    @Test func secondaryTextOnSurfaceMeetsAA() {
        let colors = PKSColorTokens.default
        for trait in [Self.lightTrait, Self.darkTrait] {
            #expect(PKSContrastValidator.meetsWCAGAA(
                foreground: colors.textSecondary, background: colors.surface, traitCollection: trait
            ))
        }
    }

    @Test func onAccentOverAccentMeetsAAForLargeText() {
        // PKSButton's .primary style renders `onAccent` text on an `accent`
        // background using the 17pt semibold buttonLabel token.
        let colors = PKSColorTokens.default
        for trait in [Self.lightTrait, Self.darkTrait] {
            #expect(PKSContrastValidator.meetsWCAGAA(
                foreground: colors.onAccent, background: colors.accent, isLargeText: true, traitCollection: trait
            ))
        }
    }

    @Test func contrastRatioIsSymmetric() {
        #expect(PKSContrastValidator.contrastRatio(.black, .white) == PKSContrastValidator.contrastRatio(.white, .black))
    }

    @Test func blackOnWhiteHasNearMaximumContrast() {
        #expect(PKSContrastValidator.contrastRatio(.black, .white) > 20.0)
    }
}
