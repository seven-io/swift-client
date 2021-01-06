struct ValidateForVoiceParams: Codable {
    var callback: String?
    var number: String

    init(number: String) {
        self.number = number
    }
}

struct ValidateForVoiceResponse: Decodable {
    var code: String?
    var error: String?
    var formatted_output: String?
    var id: String?
    var sender: String?
    var success: Bool
    var voice: Bool?
}
