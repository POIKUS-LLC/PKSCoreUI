import UIKit
import Testing
@testable import PKSCoreUI

@Suite struct PKSTypographyScalingTests {
    @Test func scaledFontGrowsWithLargerContentSizeCategory() {
        let token = PKSFontToken(font: .systemFont(ofSize: 17, weight: .regular), textStyle: .body)
        let small = UITraitCollection(preferredContentSizeCategory: .small)
        let accessibilityXL = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraLarge)

        let smallFont = token.scaledFont(compatibleWith: small)
        let largeFont = token.scaledFont(compatibleWith: accessibilityXL)

        #expect(largeFont.pointSize > smallFont.pointSize)
    }

    @Test func defaultTypographyScaleIsOrderedBySize() {
        let typography = PKSTypographyTokens.default
        #expect(typography.titleLarge.font.pointSize > typography.title.font.pointSize)
        #expect(typography.title.font.pointSize > typography.headline.font.pointSize)
        #expect(typography.headline.font.pointSize >= typography.body.font.pointSize)
        #expect(typography.body.font.pointSize > typography.caption.font.pointSize)
    }
}
