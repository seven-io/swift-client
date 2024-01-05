import Foundation

enum StringBool: String, Codable {
    case `true`
    case `false`
}

struct SevenClient {
    var client: ApiClient
    var subaccounts: Subaccounts

    init(apiKey: String = ProcessInfo.processInfo.environment["SEVEN_API_KEY"] ?? "") {
        self.client = try! ApiClient(apiKey: apiKey)
        self.subaccounts = Subaccounts(client: self.client)
    }

    public func analytics(params: AnalyticsParams) -> [AnalyticBase]? {
        let analytics = client.request(endpoint: "analytics", method: "GET", payload: params)

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

        let balance = client.request(endpoint: "balance", method: "GET", payload: BalanceParams())

        return nil == balance ? nil : Float(String(decoding: balance!, as: UTF8.self))
    }

    public func contacts(params: ContactsParams) -> Any? {
        let response = client.request(endpoint: "contacts",
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
        let res = client.request(endpoint: "hooks",
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
        let res = client.request(endpoint: "journal", method: "GET", payload: params)

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
        let res = client.request(endpoint: "lookup", method: "POST", payload: params)

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
        let res = client.request(endpoint: "pricing", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        if (PricingFormat.csv == params.format) {
            return String(decoding: res!, as: UTF8.self)
        }

        return try! JSONDecoder().decode(PricingResponse.self, from: res!)
    }

    public func sms(params: SmsParams) -> Any? {
        let res = client.request(endpoint: "sms", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        if (true != params.json) {
            return String(decoding: res!, as: UTF8.self)
        }

        return try! JSONDecoder().decode(SmsResponse.self, from: res!)
    }

    public func status(params: StatusParams) -> Any? {
        let res = client.request(endpoint: "status", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        let str = String(decoding: res!, as: UTF8.self)

        if (true != params._json) {
            return str
        }

        let lines = str.split(whereSeparator: \.isNewline)

        return StatusResponse(
                report: StatusReportCode(rawValue: String(lines[0]))!,
                timestamp: String(lines[1]))
    }

    public func validateForVoice(params: ValidateForVoiceParams)
                    -> ValidateForVoiceResponse? {
        let res = client.request(
                endpoint: "validate_for_voice", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        return try! JSONDecoder()
                .decode(ValidateForVoiceResponse.self, from: res!)
    }

    public func voice(params: VoiceParams) -> Any? {
        let res = client.request(endpoint: "voice", method: "POST", payload: params)

        if (nil == res) {
            return nil
        }

        let str = String(decoding: res!, as: UTF8.self)

        if (true != params._json) {
            return str
        }

        let lines = str.split(whereSeparator: \.isNewline)

        return VoiceResponse(
                code: Int(lines[0])!,
                cost: Float(lines[1])!,
                id: Int(lines[2])!)
    }
}
