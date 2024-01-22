struct Voice {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func validate(params: ValidateForVoiceParams) -> ValidateForVoiceResponse? {
        let res = client.request(endpoint: "validate_for_voice", method: "POST", payload: params)

        return try! JSONDecoder().decode(ValidateForVoiceResponse.self, from: res!)
    }

    public func call(params: VoiceParams) -> VoiceResponse? {
        let res = client.request(endpoint: "voice", method: "POST", payload: params)

        return try! JSONDecoder().decode(VoiceResponse.self, from: res!)
    }
}

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


struct VoiceParams: Codable {
    var text: String
    var to: String
    var xml: Bool?
    var from: String?

    init(text: String, to: String) {
        self.text = text
        self.to = to
    }
}

struct VoiceResponse: Decodable {
    var balance: Float
    var debug: Bool
    var messages: [VoiceMessage]
    var success: String
    var total_price: Float
}

struct VoiceMessage: Decodable {
    var error: String?
    var error_text: String?
    var id: Int?
    var price: Float
    var recipient: String
    var sender: String
    var success: Bool
    var text: String
}
