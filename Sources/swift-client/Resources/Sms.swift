enum SmsType: String, Codable {
  case economy
  case direct
}

enum SmsEncoding: String, Codable {
  case gsm
  case ucs2
}

struct SmsParams: Codable {
  var debug: Bool?
  var delay: String?
  var details: Bool?
  var flash: Bool?
  var foreign_id: String?
  var from: String?
  var label: String?
  var json: Bool?
  var no_reload: Bool?
  var text: String
  var to: String
  var unicode: Bool?
  var udh: String?
  var utf8: Bool?
  var ttl: Int?
  var performance_tracking: Bool?
  var return_msg_id: Bool?

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
  var   messages: [String]?
  var parts: Int
  var price: Float
  var   recipient: String
  var   sender: String
  var   success: Bool
  var   text: String
}

struct SmsResponse: Decodable {
    var debug: StringBool
    var balance: Float
    var messages: [SmsMessage]
    var sms_type: SmsType
    var success: String
    var total_price: Float
}
