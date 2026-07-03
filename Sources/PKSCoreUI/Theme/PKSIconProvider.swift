import UIKit

/// Semantic icon roles used by shipped components, defaulting to SF Symbols so the
/// package stays dependency-free (no asset catalog required).
public struct PKSIconProvider: @unchecked Sendable {
    public var info: UIImage?
    public var success: UIImage?
    public var warning: UIImage?
    public var danger: UIImage?
    public var dismiss: UIImage?
    public var share: UIImage?

    public init(
        info: UIImage? = UIImage(systemName: "info.circle.fill"),
        success: UIImage? = UIImage(systemName: "checkmark.circle.fill"),
        warning: UIImage? = UIImage(systemName: "exclamationmark.triangle.fill"),
        danger: UIImage? = UIImage(systemName: "xmark.octagon.fill"),
        dismiss: UIImage? = UIImage(systemName: "xmark"),
        share: UIImage? = UIImage(systemName: "square.and.arrow.up")
    ) {
        self.info = info
        self.success = success
        self.warning = warning
        self.danger = danger
        self.dismiss = dismiss
        self.share = share
    }

    public static let `default` = PKSIconProvider()
}
