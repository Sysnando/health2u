import XCTest
@testable import Health2u

final class SessionStoreTests: XCTestCase {
    func testInitiallyNotAuthenticated() async {
        let store = SessionStore()
        let auth = await store.isAuthenticated()
        XCTAssertFalse(auth)
    }
}
