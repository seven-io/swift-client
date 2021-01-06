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

    func testPricing() {
      var params = PricingParams()

      let obj = initClient().pricing(params: params) as! PricingResponse
      XCTAssertGreaterThanOrEqual(obj.countCountries, 0)
      XCTAssertGreaterThanOrEqual(obj.countNetworks, 0)
      XCTAssertEqual(obj.countCountries, obj.countries.count)

      for country in obj.countries {
        XCTAssertGreaterThan(country.countryName.count, 0)

        for network in country.networks {
          for feature in network.features {
            XCTAssertGreaterThan(feature.count, 0)
          }
          XCTAssertGreaterThan(network.mcc.count, 0)
          for mncs in network.mncs {
            XCTAssertGreaterThan(mncs.count, 0)
          }
          XCTAssertGreaterThan(network.price, Float(0))
        }
      }
      sleep(1)

      params.format = PricingFormat.csv
      XCTAssertGreaterThan(
        (initClient().pricing(params: params) as! String).count, 0)
      sleep(1)
    }

    func testSms() {
      let client = initClient()
      var params = SmsParams(text: "HI2U!", to: "491771783130")

      XCTAssertEqual((client.sms(params: params) as! String).count, 3)

      params.json = true
      let obj = client.sms(params: params) as! SmsResponse
      XCTAssertGreaterThanOrEqual(obj.balance, 0)
      XCTAssertNotNil(obj.debug)
      XCTAssertNotNil(obj.sms_type)
      XCTAssertEqual(obj.success.count, 3)
      XCTAssertGreaterThanOrEqual(obj.total_price, Float(0))

      for msg in obj.messages {
        XCTAssertNotNil(msg.encoding)
        XCTAssertGreaterThan((msg.error ?? " ").count, 0)
        XCTAssertGreaterThan((msg.error_text ?? " ").count, 0)
        XCTAssertGreaterThan((msg.id ?? " ").count, 0)
        XCTAssertGreaterThan(msg.parts, 0)
        XCTAssertGreaterThanOrEqual(msg.price, Float(0))
        XCTAssertGreaterThan(msg.recipient.count, 0)
        XCTAssertGreaterThan(msg.sender.count, 0)
        XCTAssertNotNil(msg.success)
        XCTAssertGreaterThan(msg.text.count, 0)

        if nil != msg.messages {
          for message in msg.messages! {
            XCTAssertGreaterThan(message.count, 0)
          }
        }
      }
      sleep(1)
    }

    func testStatus() {
      let client = initClient()
      var params = StatusParams(msg_id: "77133086945")

      XCTAssertEqual((client.status(params: params) as! String)
      .split(whereSeparator: \.isNewline).count, 2)

      sleep(1)
    }

    static var allTests = [
      ("testAnalytics", testAnalytics),
      ("testBalance", testBalance),
      ("testContacts", testContacts),
      ("testHooks", testHooks),
      ("testJournal", testJournal),
      ("testLookup", testLookup),
      ("testPricing", testPricing),
      ("testSms", testSms),
      ("testStatus", testStatus),
    ]
}
