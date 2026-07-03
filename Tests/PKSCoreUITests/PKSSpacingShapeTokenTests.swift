import Testing
@testable import PKSCoreUI

@Suite struct PKSSpacingShapeTokenTests {
    @Test func spacingScaleIsMonotonicallyIncreasing() {
        let spacing = PKSSpacingTokens.default
        #expect(spacing.xs < spacing.sm)
        #expect(spacing.sm < spacing.md)
        #expect(spacing.md < spacing.lg)
        #expect(spacing.lg < spacing.xl)
    }

    @Test func shapeScaleIsMonotonicallyIncreasing() {
        let shape = PKSShapeTokens.default
        #expect(shape.small < shape.medium)
        #expect(shape.medium < shape.large)
        #expect(shape.large < shape.pill)
    }

    @Test func motionScaleIsMonotonicallyIncreasing() {
        let motion = PKSMotionTokens.default
        #expect(motion.fast < motion.standard)
        #expect(motion.standard < motion.slow)
    }
}
