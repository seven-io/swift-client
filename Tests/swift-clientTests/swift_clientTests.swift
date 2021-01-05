import XCTest
@testable import swift_client

final class swift_clientTests: XCTestCase {
    func initClient() -> swift_client {
        var client = try! swift_client(apiKey: ProcessInfo.processInfo.environment["SMS77_DUMMY_API_KEY"]!)

        client.debug = true
        client.sentWith = "Swift-Test"

        return client
    }

    func testAnalytics() {
        for analytic in initClient().analytics(params: AnalyticsParams())! {
            if nil != analytic.direct {
                XCTAssertGreaterThanOrEqual(analytic.direct!, 0)
            }
            if nil != analytic.economy {
                XCTAssertGreaterThanOrEqual(analytic.economy!, 0)
            }
            XCTAssertGreaterThanOrEqual(analytic.hlr!, 0)
            XCTAssertGreaterThanOrEqual(analytic.inbound!, 0)
            XCTAssertGreaterThanOrEqual(analytic.mnp!, 0)
            XCTAssertGreaterThanOrEqual(analytic.usage_eur!, Float(0))
            XCTAssertGreaterThanOrEqual(analytic.voice!, 0)
        }
    }

    func testBalance() {
        XCTAssertGreaterThanOrEqual(initClient().balance()!, Float(0))
    }

    func testContacts() {
        var readParams = ContactsParams(action: ContactsAction.read)

        XCTAssertGreaterThanOrEqual((initClient().contacts(params: readParams) as! String).count, 0)

        readParams.json = true
        for contact in initClient().contacts(params: readParams) as! [Contact] {
            XCTAssertNotEqual(contact.ID!, "0") //  if (nil != contact.id) {}
            XCTAssertNotNil(contact.Name)
            XCTAssertNotNil(contact.Number)
        }
    }

    static var allTests = [
        ("testAnalytics", testAnalytics),
        ("testBalance", testBalance),
        ("testContacts", testContacts),
    ]
}
