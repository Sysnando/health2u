import XCTest
@testable import Health2u

final class ThemeTests: XCTestCase {
    func testSpaceTokens() {
        XCTAssertEqual(Dimensions.Space.m, 16)
        XCTAssertEqual(Dimensions.Space.s, 8)
    }

    func testCornerRadius() {
        XCTAssertEqual(Dimensions.CornerRadius.full, 999)
    }
}
