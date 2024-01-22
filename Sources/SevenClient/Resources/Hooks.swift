struct Hooks {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func read(params: HooksParams) -> HooksReadResponse? {
        let params = HooksParams(HooksAction.read)
        let res = client.request(endpoint: "hooks", method: "GET", payload: params)

        return try! JSONDecoder().decode(HooksReadResponse.self, from: res!)
    }

    public func subscribe(params: HooksParams) -> HooksSubscribeResponse? {
        let params = HooksParams(HooksAction.subscribe)
        let res = client.request(endpoint: "hooks", method: "POST", payload: params)

        return try! JSONDecoder().decode(HooksSubscribeResponse.self, from: res!)
    }

    public func unsubscribe(params: HooksParams) -> HooksUnsubscribeResponse? {
        let params = HooksParams(HooksAction.unsubscribe)
        let res = client.request(endpoint: "hooks", method: "POST", payload: params)

        return try! JSONDecoder().decode(HooksUnsubscribeResponse.self, from: res!)
    }
}

struct HooksParams: Codable {
    var action: HooksAction
    var event_filter: String?
    var event_type: HookEventType?
    var request_method: HookRequestMethod?
    var target_url: String?

    init(action: HooksAction) {
        self.action = action
    }
}

enum HooksAction: String, Codable {
    case subscribe
    case read
    case unsubscribe
}

enum HookRequestMethod: String, Codable {
    case POST
    case GET
}

enum HookEventType: String, Codable {
    case sms_mo
    case dlr
    case voice_status
    case all
    case tracking
    case voice_call
}

struct Hook: Decodable {
    var created: String
    var event_filter: String?
    var event_type: HookEventType
    var id: String
    var request_method: HookRequestMethod
    var target_url: String
}

struct HooksSubscribeResponse: Decodable {
    var id: Int?
    var success: Bool
}

struct HooksUnsubscribeResponse: Decodable {
    var success: Bool
}

struct HooksReadResponse: Decodable {
    var hooks: [Hook]?
    var success: Bool
}
