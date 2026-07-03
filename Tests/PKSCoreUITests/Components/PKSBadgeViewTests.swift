import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSBadgeViewTests {
    @Test func updateChangesTextAndAccessibilityLabel() {
        let badge = PKSBadgeView(text: "pending", style: .warning)
        #expect(badge.accessibilityLabel == "pending")

        badge.update(text: "active", style: .success)
        #expect(badge.accessibilityLabel == "active")
    }
}
