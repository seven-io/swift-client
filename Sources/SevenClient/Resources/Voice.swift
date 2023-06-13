struct VoiceParams: Codable {
    var _json: Bool?
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
    let code: Int
    let cost: Float
    let id: Int

    init(code: Int, cost: Float, id: Int) {
        self.code = code
        self.cost = cost
        self.id = id
    }
}
