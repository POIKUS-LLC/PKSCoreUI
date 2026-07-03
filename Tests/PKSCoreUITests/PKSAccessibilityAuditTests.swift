import UIKit
import Testing
@testable import PKSCoreUI
import PKSCoreUITestSupport

@MainActor
@Suite struct PKSAccessibilityAuditTests {
    @Test func isAccessibilityCategoryBoundary() {
        #expect(!PKSAccessibility.isAccessibilityCategory(.large))
        #expect(!PKSAccessibility.isAccessibilityCategory(.extraExtraExtraLarge))
        #expect(PKSAccessibility.isAccessibilityCategory(.accessibilityMedium))
        #expect(PKSAccessibility.isAccessibilityCategory(.accessibilityExtraExtraExtraLarge))
    }

    @Test func buttonExpandsHitAreaBelowMinimumTapTarget() {
        let button = PKSButton(style: .primary, title: "Go")
        _ = pks_makeOffscreenWindow(for: button, size: CGSize(width: 30, height: 20))
        // Visual bounds (30x20) are below the 44x44 HIG minimum; PKSButton must
        // still expand its effective hit area to compensate.
        #expect(button.point(inside: CGPoint(x: -5, y: -5), with: nil))
        #expect(button.point(inside: CGPoint(x: 35, y: 18), with: nil))
        #expect(!button.point(inside: CGPoint(x: -10, y: -15), with: nil))
    }

    @Test func bannerViewHasAccessibilityLabel() {
        let banner = PKSBannerView(style: .accent, title: "Invite a friend", message: "Earn rewards")
        _ = pks_makeOffscreenWindow(for: banner)
        #expect(banner.isAccessibilityElement)
        #expect(!(banner.accessibilityLabel?.isEmpty ?? true))
    }

    @Test func emptyStateHasAccessibilityLabel() {
        let empty = PKSEmptyStateView(title: "No referrals yet", message: "Invite friends to get started")
        _ = pks_makeOffscreenWindow(for: empty)
        #expect(!(empty.accessibilityLabel?.isEmpty ?? true))
    }

    @Test func errorStateHasAccessibilityLabel() {
        let error = PKSErrorStateView(message: "Network unavailable", onRetry: {})
        _ = pks_makeOffscreenWindow(for: error)
        #expect(!(error.accessibilityLabel?.isEmpty ?? true))
    }

    @Test func badgeViewHasAccessibilityLabel() {
        let badge = PKSBadgeView(text: "active", style: .success)
        _ = pks_makeOffscreenWindow(for: badge, size: CGSize(width: 80, height: 24))
        #expect(badge.accessibilityLabel == "active")
    }

    @Test func listRowViewHasComposedAccessibilityLabel() {
        let row = PKSListRowView()
        row.configure(title: "Referral bonus", subtitle: "Earned Jan 2")
        _ = pks_makeOffscreenWindow(for: row)
        #expect(row.accessibilityLabel == "Referral bonus, Earned Jan 2")
    }
}
