struct JournalParams: Codable {
  var   date_from: String?
  var   date_to: String?
  var   id: Int?
  var   state: String?
  var   to: String?
  var   type: JournalType

    init(type: JournalType) {self.type = type}
}

enum JournalType: String, Codable {
  case outbound
  case inbound
  case voice
  case replies
}

protocol JournalBase: Codable {
  var   from: String { get set }
  var   id: String { get set }
  var   price: String { get set }
  var   text: String { get set }
  var   timestamp: String { get set }
  var   to: String { get set }
}

struct JournalReplies: JournalBase {
  var   from: String
  var   id: String
  var   price: String
  var   text: String
  var   timestamp: String
  var   to: String
}

struct JournalInbound: JournalBase {
  var   from: String
  var   id: String
  var   price: String
  var   text: String
  var   timestamp: String
  var   to: String
}

struct JournalOutbound: JournalBase {
  var   from: String
  var   id: String
  var   price: String
  var   text: String
  var   timestamp: String
  var   to: String

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
  var   from: String
  var   id: String
  var   price: String
  var   text: String
  var   timestamp: String
  var   to: String

  var duration: String
  var error: String
  var status: String
  var xml: Bool
}
