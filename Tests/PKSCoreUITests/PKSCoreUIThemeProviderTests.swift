import Foundation
import Testing
@testable import PKSCoreUI

@MainActor
@Suite struct PKSCoreUIThemeProviderTests {
    @Test func configureUpdatesTheme() {
        let customTheme = PKSCoreUITheme(colors: PKSColorTokens(accent: .systemPink))
        PKSCoreUI.configure(customTheme)
        #expect(PKSCoreUI.theme.colors.accent == .systemPink)
        PKSCoreUI.configure(.default)
    }

    @Test func configurePostsChangeNotificationSynchronously() {
        var received = false
        // queue: nil delivers synchronously on the posting thread, so this doesn't
        // race the assertion below.
        let observer = NotificationCenter.default.addObserver(
            forName: .pksCoreUIThemeDidChange,
            object: nil,
            queue: nil
        ) { _ in received = true }
        defer { NotificationCenter.default.removeObserver(observer) }

        PKSCoreUI.configure(.default)
        #expect(received)
    }
}
