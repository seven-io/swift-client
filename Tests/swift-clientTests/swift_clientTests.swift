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

        sleep(1)
    }

    func testBalance() {
        XCTAssertGreaterThanOrEqual(initClient().balance()!, Float(0))

        sleep(1)
    }

    func testContacts() {
        var readParams =  ContactsParams(action: ContactsAction.read)


        XCTAssertGreaterThanOrEqual((initClient().contacts(params: readParams) as! String).count, 0)

        readParams.json = true
        for contact in initClient().contacts(params: readParams) as! [Contact] {
            XCTAssertNotEqual(contact.ID!, "0")
            XCTAssertNotNil(contact.Name)
            XCTAssertNotNil(contact.Number)
        }

        sleep(1)
    }

    func testHooks() {
        let readParams = HooksParams(action: HooksAction.read)
        let res = initClient().hooks(params: readParams) as! HooksReadResponse

        for hook in res.hooks! {
            XCTAssertNotEqual(hook.created.count, 0)
            XCTAssertNotNil(hook.event_type)
            XCTAssertNotEqual(hook.id.count, 0)
            XCTAssertNotNil(hook.request_method)
            XCTAssertNotEqual(hook.target_url.count, 0)
        }

        sleep(1)
    }

    func testJournal() {
        func baseAsserts(base: JournalBase) {
          XCTAssertNotNil(base.from.count)
          XCTAssertNotEqual(base.id.count, 0)
          XCTAssertNotEqual(base.price.count, 0)
          XCTAssertNotNil(base.text.count)
          XCTAssertNotEqual(base.timestamp.count, 0)
          XCTAssertNotNil(base.to.count)
        }

        let journals =
        initClient().journal(params: JournalParams(type: JournalType.outbound))
         as! [JournalOutbound]

        for journal in journals {
          baseAsserts(base: journal)

          XCTAssertNotEqual(journal.connection.count, 0)
          XCTAssertNotEqual(journal.type.count, 0)
        }

        sleep(1)
    }

    func testLookup() {
        let client = initClient()
        var mnpParams = LookupParams(type: LookupType.mnp, number: "491771783130")

        XCTAssertEqual(client.lookup(params: mnpParams) as! String, "eplus")
        sleep(1)

        mnpParams.json = true
        let res = client.lookup(params: mnpParams) as! LookupMnpJsonResponse
        XCTAssertGreaterThan(res.mnp.country.count, 0)
        XCTAssertGreaterThan(res.mnp.international_formatted.count, 0)
        XCTAssertGreaterThan(res.mnp.mccmnc.count, 0)
        XCTAssertGreaterThan(res.mnp.national_format.count, 0)
        XCTAssertGreaterThan(res.mnp.network.count, 0)
        XCTAssertGreaterThan(res.mnp.number.count, 0)
        XCTAssertGreaterThanOrEqual(res.code, 100)
        XCTAssertGreaterThanOrEqual(res.price, Float(0))
        sleep(1)
    }

    static var allTests = [
        ("testAnalytics", testAnalytics),
        ("testBalance", testBalance),
        ("testContacts", testContacts),
        ("testHooks", testHooks),
        ("testJournal", testJournal),
        ("testLookup", testLookup),
    ]
}
