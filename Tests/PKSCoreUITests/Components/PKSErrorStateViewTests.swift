import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSErrorStateViewTests {
    @Test func defaultsProduceNonEmptyAccessibilityLabel() {
        let error = PKSErrorStateView(onRetry: {})
        #expect(!(error.accessibilityLabel?.isEmpty ?? true))
    }

    @Test func customTitleAndMessageAppearInAccessibilityLabel() {
        let error = PKSErrorStateView(title: "Network Error", message: "Check your connection.", onRetry: {})
        #expect(error.accessibilityLabel == "Network Error. Check your connection.")
    }
}
