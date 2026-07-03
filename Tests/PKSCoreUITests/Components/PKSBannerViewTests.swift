import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSBannerViewTests {
    @Test func accessibilityLabelCombinesTitleAndMessage() {
        let banner = PKSBannerView(style: .info, title: "Invite a friend", message: "Earn rewards when they join.")
        #expect(banner.accessibilityLabel == "Invite a friend. Earn rewards when they join.")
    }

    @Test func actionExposedAsCustomAccessibilityAction() {
        let banner = PKSBannerView(style: .accent, title: "Invite", actionTitle: "Share")
        #expect(banner.accessibilityCustomActions?.contains { $0.name == "Share" } == true)
    }

    @Test func dismissExposedAsCustomAccessibilityActionOnlyWhenDismissable() {
        let notDismissable = PKSBannerView(style: .accent, title: "Invite")
        #expect(notDismissable.accessibilityCustomActions?.contains { $0.name == "Dismiss" } != true)

        let dismissable = PKSBannerView(style: .accent, title: "Invite", isDismissable: true)
        #expect(dismissable.accessibilityCustomActions?.contains { $0.name == "Dismiss" } == true)
    }
}
