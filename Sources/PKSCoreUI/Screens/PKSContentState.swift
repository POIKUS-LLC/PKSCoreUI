import Foundation

/// The state a `PKSStatefulViewController`-based screen can be in. `.content` means
/// whatever the subclass installed into `contentContainer` is shown; the other three
/// cases swap in a shared state view instead.
public enum PKSContentState: Sendable {
    case loading(message: String?)
    case content
    case empty(title: String, message: String?, actionTitle: String?)
    case error(title: String, message: String?, retryTitle: String)
}
