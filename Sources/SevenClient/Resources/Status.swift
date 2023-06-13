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
    var _json: Bool?
    var msg_id: String

    init(msg_id: String) {
        self.msg_id = msg_id
    }
}

struct StatusResponse {
    var report: StatusReportCode
    var timestamp: String

    init(report: StatusReportCode, timestamp: String) {
        self.report = report
        self.timestamp = timestamp
    }
}
