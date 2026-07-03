# PKSCoreUI

Shared UIKit design-system foundation for Poikus iOS apps: theming (accent color, typography,
spacing, shape, elevation, motion), accessible base components (buttons, cards, banners, list
rows, badges, empty/loading/error states, toasts, alerts, activity sharing), and a screen shell
for composing loading/content/empty/error states. Configure a theme once at launch and every
consuming feature package gets consistent, accessible UI — fix something here and it's fixed
everywhere.

`PKSCoreUI` depends only on `PKSCore`. It does not contain feature-specific screens (e.g. referral
UI) — those live in a downstream package that depends on both `PKSCoreUI` and the feature's SDK.

## Requirements

- iOS 16+
- Swift 6

`PKSCoreUI` imports UIKit throughout and does not support macOS. Because of this, `swift test`
cannot run its test suite (UIKit doesn't build for plain macOS); use `xcodebuild test` against an
iOS Simulator destination instead:

```sh
xcodebuild test -scheme PKSCoreUI -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Installation

```swift
.package(url: "https://github.com/POIKUS-LLC/PKSCoreUI.git", .upToNextMinor(from: "0.1.0"))
```

## Local development

Inside the `poikussource` monorepo, `Package.swift` resolves `PKSCore` from GitHub by default (pinned
to a released version), so a fresh checkout is always prod-ready with no extra setup. To build against
the sibling `pkscore` folder on disk instead — e.g. while developing both packages together — export:

```sh
export PKS_LOCAL_PACKAGES=1
```

before running `swift build`, `swift test`, or `xcodebuild`. This only applies inside the monorepo,
where the sibling package folders actually exist.

## API

```swift
import PKSCoreUI

// Configure once at app launch.
PKSCoreUI.configure(
    PKSCoreUITheme(
        colors: PKSColorTokens(accent: .systemPurple)
    )
)

// Components read the shared theme automatically.
let button = PKSButton(style: .primary, title: "Invite Friends")

let card = PKSCardView()
card.contentView.addSubview(button)

let banner = PKSBannerView(
    style: .accent,
    title: "Invite a friend",
    message: "Earn rewards when they join.",
    actionTitle: "Share"
) { /* ... */ }

// Status pills map arbitrary backend status strings to a style — no fixed enum.
let badge = PKSBadgeView(text: "active", style: { status in
    status == "active" ? .success : .neutral
})

// Screens compose loading/content/empty/error via PKSStatefulViewController.
final class DashboardViewController: PKSStatefulViewController {
    override func loadingView() -> UIView { PKSLoadingStateView(label: "Loading…") }
}
```

## License

Apache-2.0
