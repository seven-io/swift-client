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

        if (nil != balance) {
            XCTAssertGreaterThanOrEqual(balance!, Float(0))
        }
    }

    func testAnalytics() {
        let analytics = initClient().analytics(params: AnalyticsParams())

        if (nil == analytics) {
            XCTAssertNil(analytics)
        } else {
            for analytic in analytics! {
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.direct!, 0)
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.economy!, 0)
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
                }
                if (nil != analytic.direct) {
                    XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
                }
            }
        }
    }

    static var allTests = [
        //("testAnalytics", testAnalytics),
        ("testBalance", testBalance),
    ]
}
