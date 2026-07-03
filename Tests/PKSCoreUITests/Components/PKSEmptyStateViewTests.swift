import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSEmptyStateViewTests {
    @Test func accessibilityLabelCombinesTitleAndMessage() {
        let empty = PKSEmptyStateView(title: "No referrals yet", message: "Invite friends to get started")
        #expect(empty.accessibilityLabel == "No referrals yet. Invite friends to get started")
    }

    @Test func accessibilityLabelOmitsMessageWhenNil() {
        let empty = PKSEmptyStateView(title: "No referrals yet")
        #expect(empty.accessibilityLabel == "No referrals yet")
    }
}
