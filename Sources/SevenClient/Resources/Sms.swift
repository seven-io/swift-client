struct SmsStatus {
    var id: String
    var status: String
    var status_time: String
}

enum StatusReportCode: String, Codable {
    case DELIVERED
    case NOTDELIVERED
    case BUFFERED
    case TRANSMITTED
    case ACCEPTED
    case EXPIRED
    case REJECTED
    case FAILED
    case UNKNOWN
}

struct StatusParams: Codable {
    var msg_id: String

    init(msg_id: String) {
        self.msg_id = msg_id
    }
}

struct Sms {
   var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func delete(params: SmsDeleteParams) -> SmsDeleteResponse? {
        let res = client.request(endpoint: "sms", method: "DELETE", payload: params)

        return try! JSONDecoder().decode(SmsDeleteResponse.self, from: res!)
    }

    public func dispatch(params: SmsParams) -> SmsResponse? {
        let res = client.request(endpoint: "sms", method: "POST", payload: params)

        return try! JSONDecoder().decode(SmsResponse.self, from: res!)
    }

    public func status(params: StatusParams) -> [SmsStatus]? {
        let res = client.request(endpoint: "status", method: "GET", payload: params)

        if (nil == res) {
            return nil
        }

        return try! JSONDecoder().decode([SmsStatus].self, from: res!)
    }
}

enum SmsType: String, Codable {
    case economy
    case direct
}

enum SmsEncoding: String, Codable {
    case gsm
    case ucs2
}

struct SmsDeleteParams: Codable {
    var ids: [Int]

    init(ids: [Int]) {
        self.ids = ids
    }
}

struct SmsDeleteResponse: Decodable {
    var deleted: [String]
    var success: Bool
}

struct SmsParams: Codable {
    var delay: String?
    // var details: Bool?
    var flash: Bool?
    var foreign_id: String?
    var from: String?
    var label: String?
    // var json: Bool?
    var no_reload: Bool?
    var text: String
    var to: String
    var unicode: Bool?
    var udh: String?
    var utf8: Bool?
    var ttl: Int?
    var performance_tracking: Bool?
    // var return_msg_id: Bool?

    init(text: String, to: String) {
        self.text = text
        self.to = to
    }
}

struct SmsMessage: Decodable {
    var encoding: SmsEncoding
    var error: String?
    var error_text: String?
    var id: String?
    var messages: [String]?
    var parts: Int
    var price: Float
    var recipient: String
    var sender: String
    var success: Bool
    var text: String
}

struct SmsResponse: Decodable {
    var debug: StringBool
    var balance: Float
    var messages: [SmsMessage]
    var sms_type: SmsType
    var success: String
    var total_price: Float
}
