import XCTest
@testable import Health2u

final class ComponentsTests: XCTestCase {
    func testPrimaryButtonCompiles() {
        _ = PrimaryButton(title: "x") {}
    }
}
