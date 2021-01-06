import Foundation
import FoundationNetworking

enum InvalidArgumentError: Error {
    case emptyApiKey
}

enum StringBool: String, Codable {
  case `true`
  case `false`
}

struct swift_client {
    var debug: Bool = false
    var sentWith: String = "Swift"
    var apiKey: String

    init(apiKey: String = ProcessInfo.processInfo.environment["SMS77_API_KEY"] ?? "") throws {
        guard !apiKey.isEmpty else {
            throw InvalidArgumentError.emptyApiKey
        }

        self.apiKey = apiKey
    }

    private func request<V>(endpoint: String, method: String = "GET", payload: V?) -> Data? where V: Codable {
        let isGET = "GET" == method
        let hasPayload = nil != payload
        let group = DispatchGroup()
        group.enter()

        var body: Data? = nil
        var response: Data? = nil
        var to = "https://gateway.sms77.io/api/" + endpoint

        if hasPayload {
            let encodedPayload = try! JSONEncoder().encode(payload)
            //print(String(data: encodedPayload, encoding: String.Encoding.utf8) as Any)
            let children = Mirror(reflecting: try! JSONDecoder().decode(V.self, from: encodedPayload)).children
            if !children.isEmpty {
                var p: [String: String] = [:]

                /*
                if isGET {
                    to += "?"
                }
                */

                to += "?"

                var i = 0
                for child in children {
                    var value = child.value

                    if nil != child.label {
                        let label = child.label!

                        if value is Bool {
                            value = false == value as! Bool ? 0 : 1
                        }

                        value = "\(value)"

                        if "nil" != value as! String {
                            to += "\(0 == i ? "" : "&")\(label)=\(value)"

                          /*
                            if isGET {
                                to += "\(0 == i ? "" : "&")\(label)=\(value)"
                            } else {
                                p[label] = (value as! String)
                            }
                            */
                        }
                    }

                    i += 1
                }

                if !p.isEmpty {
                    body = encodedPayload
                }
            }
        }
        print("to: \(to)")
        var request = URLRequest(url: URL(string: to)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = method
        request.addValue("Basic " + ProcessInfo.processInfo.environment["SMS77_DUMMY_API_KEY"]!,
                forHTTPHeaderField: "Authorization")
        request.addValue(sentWith, forHTTPHeaderField: "sentWith")
        if nil != body {
            //print("body: ", body as Any)
            //request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, res, error in
            response = data

            if nil != error {
                print("error: ", error as Any)
                print("res: ", res as Any)
            }

            if debug {
                print("response: ", response as Any)
            }

            group.leave()
        }.resume()

        group.wait()

        return response
    }

    public func analytics(params: AnalyticsParams) -> [AnalyticBase]? {
        let analytics = request(endpoint: "analytics", method: "GET", payload: params)

        if (nil == analytics) {
            return nil
        }

        switch params.group_by {
        case .date:
            return try! JSONDecoder().decode([AnalyticGroupByDate].self, from: analytics!)
        case .label:
            return try! JSONDecoder().decode([AnalyticGroupByLabel].self, from: analytics!)
        case .subaccount:
            return try! JSONDecoder().decode([AnalyticGroupBySubaccount].self, from: analytics!)
        case .country:
            return try! JSONDecoder().decode([AnalyticGroupByCountry].self, from: analytics!)
        }
    }

    public func balance() -> Float? {
        struct BalanceParams: Codable {
        }

        let balance = request(endpoint: "balance", method: "GET", payload: BalanceParams())

        return nil == balance ? nil : Float(String(decoding: balance!, as: UTF8.self))
    }

    public func contacts(params: ContactsParams) -> Any? {
        let response = request(endpoint: "contacts",
         method: ContactsAction.del == params.action ? "POST" : "GET",
                payload: params)

        if (nil == response) {
            return nil
        }

        if (true != params.json) {
            return String(decoding: response!, as: UTF8.self)
        }

        switch params.action {
        case .read:
            return try! JSONDecoder().decode([Contact].self, from: response!)
        case .write:
            return try! JSONDecoder().decode(ContactsWriteResponse.self, from: response!)
        case .del:
            return try! JSONDecoder().decode(ContactsWriteResponse.self, from: response!)
        }
    }

    public func hooks(params: HooksParams) -> Any? {
        let res = request(endpoint: "hooks",
                 method: HooksAction.read == params.action ? "GET" : "POST",
                payload: params)

        if (nil == res) {
            return nil
        }

        switch params.action {
        case .read:
            return try! JSONDecoder().decode(HooksReadResponse.self, from: res!)
        case .subscribe:
            return try! JSONDecoder().decode(HooksSubscribeResponse.self, from: res!)
        case .unsubscribe:
            return try! JSONDecoder().decode(HooksUnsubscribeResponse.self, from: res!)
        }
    }

    public func journal(params: JournalParams) -> [JournalBase]? {
        let res = request(endpoint: "journal", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        switch params.type {
        case .outbound:
            return try! JSONDecoder().decode([JournalOutbound].self, from: res!)
        case .inbound:
            return try! JSONDecoder().decode([JournalInbound].self, from: res!)
        case .voice:
            return try! JSONDecoder().decode([JournalVoice].self, from: res!)
        case .replies:
            return try! JSONDecoder().decode([JournalReplies].self, from: res!)
        }
    }

    public func lookup(params: LookupParams) -> Any? {
        let res = request(endpoint: "lookup", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        if (LookupType.mnp == params.type && true != params.json) {
            return String(decoding: res!, as: UTF8.self)
        }

        switch params.type {
        case .cnam:
            return try! JSONDecoder().decode(LookupCnamResponse.self, from: res!)
        case .mnp:
            return try! JSONDecoder().decode(LookupMnpJsonResponse.self, from: res!)
        case .format:
            return try! JSONDecoder().decode(LookupFormatResponse.self, from: res!)
        case .hlr:
            return try! JSONDecoder().decode(LookupHlrResponse.self, from: res!)
        }
    }

    public func pricing(params: PricingParams) -> Any? {
        let res = request(endpoint: "pricing", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        if (PricingFormat.csv == params.format) {
            return String(decoding: res!, as: UTF8.self)
        }

        return try! JSONDecoder().decode(PricingResponse.self, from: res!)
    }

    public func sms(params: SmsParams) -> Any? {
        let res = request(endpoint: "sms", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        if (true != params.json) {
            return String(decoding: res!, as: UTF8.self)
        }

        return try! JSONDecoder().decode(SmsResponse.self, from: res!)
    }

    public func status(params: StatusParams) -> Any? {
        let res = request(endpoint: "status", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        let str = String(decoding: res!, as: UTF8.self)

        if (true != params._json) {
            return str
        }

        let lines = str.split(whereSeparator: \.isNewline)

        return StatusResponse(
        report: lines[0] as! StatusReportCode, timestamp: lines[1] as! String)
    }

    public func validateForVoice(params: ValidateForVoiceParams)
    -> ValidateForVoiceResponse? {
        let res = request(
          endpoint: "validate_for_voice", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        return try! JSONDecoder()
          .decode(ValidateForVoiceResponse.self, from: res!)
    }
}
