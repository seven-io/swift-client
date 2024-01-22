struct Journal {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    private func request(params: JournalParams) -> [Any]? {
        return client.request(endpoint: "journal", method: "GET", payload: params)
    }

    public func inbound(params: JournalParams) -> [JournalInbound]? {
        params.type = JournalType.inbound
        let res = request(params)

        return try! JSONDecoder().decode([JournalInbound].self, from: res!)
    }

    public func outbound(params: JournalParams) -> [JournalOutbound]? {
        params.type = JournalType.outbound
        let res = request(params)

        return try! JSONDecoder().decode([JournalOutbound].self, from: res!)
    }

    public func voice(params: JournalParams) -> [JournalVoice]? {
        params.type = JournalType.voice
        let res = request(params)

        return try! JSONDecoder().decode([JournalVoice].self, from: res!)
    }

    public func replies(params: JournalParams) -> [JournalReplies]? {
        params.type = JournalType.replies
        let res = request(params)

        return try! JSONDecoder().decode([JournalReplies].self, from: res!)
    }
}

struct JournalParams: Codable {
    var date_from: String?
    var date_to: String?
    var id: Int?
    var limit: Int?
    var state: String?
    var to: String?
    var type: JournalType

    init(type: JournalType) {
        self.type = type
    }
}

enum JournalType: String, Codable {
    case outbound
    case inbound
    case voice
    case replies
}

protocol JournalBase: Codable {
    var from: String { get set }
    var id: String { get set }
    var price: String { get set }
    var text: String { get set }
    var timestamp: String { get set }
    var to: String { get set }
}

struct JournalReplies: JournalBase {
    var from: String
    var id: String
    var price: String
    var text: String
    var timestamp: String
    var to: String
}

struct JournalInbound: JournalBase {
    var from: String
    var id: String
    var price: String
    var text: String
    var timestamp: String
    var to: String
}

struct JournalOutbound: JournalBase {
    var from: String
    var id: String
    var price: String
    var text: String
    var timestamp: String
    var to: String

    var connection: String
    var dlr: String?
    var dlr_timestamp: String?
    var foreign_id: String?
    var label: String?
    var latency: String?
    var mccmnc: String?
    var type: String
}

struct JournalVoice: JournalBase {
    var from: String
    var id: String
    var price: String
    var text: String
    var timestamp: String
    var to: String

    var duration: String
    var error: String
    var status: String
    var xml: Bool
}
