import XCTest
@testable import swift_client

final class swift_clientTests: XCTestCase {
    func initClient() -> swift_client {
        var client = swift_client()

        client.debug = true

        return client
    }

    func testBalance() {
        let balance = initClient().balance()

        if (nil == balance) {
            XCTAssertNil(balance)
        } else {
            XCTAssertGreaterThanOrEqual(balance!, Float(0))
        }
    }

    static var allTests = [
        ("testBalance", testBalance),
    ]
}
