import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSListRowViewTests {
    @Test func accessibilityLabelIncludesAllParts() {
        let row = PKSListRowView()
        row.configure(title: "Referral bonus", subtitle: "Earned Jan 2", accessory: .text("$5.00"))
        #expect(row.accessibilityLabel == "Referral bonus, Earned Jan 2, $5.00")
    }

    @Test func accessibilityLabelOmitsMissingParts() {
        let row = PKSListRowView()
        row.configure(title: "Referral bonus")
        #expect(row.accessibilityLabel == "Referral bonus")
    }
}
