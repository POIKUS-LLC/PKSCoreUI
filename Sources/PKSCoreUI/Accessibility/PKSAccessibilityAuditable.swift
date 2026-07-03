import UIKit

/// Conformance point for `PKSAccessibilityAuditTests`: every shipped component that
/// renders visible/interactive content conforms, so a new component is automatically
/// covered by the audit sweep instead of relying on someone remembering to test it.
/// See the "Adding a Component" checklist in the README.
@MainActor
public protocol PKSAccessibilityAuditable {
    /// An instance configured with representative, non-empty content and laid out at a
    /// realistic size, ready for the audit test to inspect (label, frame, contrast).
    static func makeAuditInstance() -> Self
}

/// A single accessibility problem surfaced by an audit sweep.
public struct PKSAccessibilityAuditIssue: CustomStringConvertible, Sendable {
    public enum Kind: Sendable {
        case missingAccessibilityLabel
        case tapTargetTooSmall(width: Double, height: Double)
        case insufficientContrast(ratio: Double, required: Double)
    }

    public let componentName: String
    public let kind: Kind

    public init(componentName: String, kind: Kind) {
        self.componentName = componentName
        self.kind = kind
    }

    public var description: String {
        switch kind {
        case .missingAccessibilityLabel:
            return "\(componentName): missing accessibilityLabel"
        case .tapTargetTooSmall(let width, let height):
            return "\(componentName): tap target \(width)x\(height) is below the 44x44 minimum"
        case .insufficientContrast(let ratio, let required):
            return "\(componentName): contrast ratio \(ratio) is below required \(required)"
        }
    }
}
