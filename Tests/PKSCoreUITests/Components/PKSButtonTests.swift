import UIKit
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSButtonTests {
    @Test func initSetsTitleAndButtonTrait() {
        let button = PKSButton(style: .primary, title: "Invite Friends")
        #expect(button.configuration?.title == "Invite Friends")
        #expect(button.accessibilityTraits.contains(.button))
    }

    @Test func stylesProduceDistinctBackgroundColors() {
        let primary = PKSButton(style: .primary, title: "A")
        let secondary = PKSButton(style: .secondary, title: "B")
        #expect(primary.configuration?.background.backgroundColor != secondary.configuration?.background.backgroundColor)
    }
}
