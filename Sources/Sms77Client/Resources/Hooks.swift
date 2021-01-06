struct HooksParams: Codable {
    var action: HooksAction
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
}

struct Hook: Decodable {
    var created: String
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
