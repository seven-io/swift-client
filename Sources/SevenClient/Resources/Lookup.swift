struct Lookup {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func cnam(params: LookupParams) -> [LookupCnamResponse]? {
        params.type = LookupType.cnam
        let res = client.request(endpoint: "lookup", method: "POST", payload: params)

        return try! JSONDecoder().decode([LookupCnamResponse].self, from: res!)
    }

    public func format(params: LookupParams) -> [LookupFormatResponse]? {
        params.type = LookupType.format
        let res = client.request(endpoint: "lookup", method: "POST", payload: params)

        return try! JSONDecoder().decode([LookupFormatResponse].self, from: res!)
    }

    public func hlr(params: LookupParams) -> [LookupHlrResponse]? {
        params.type = LookupType.hlr
        let res = client.request(endpoint: "lookup", method: "POST", payload: params)

        return try! JSONDecoder().decode([LookupHlrResponse].self, from: res!)
    }

    public func mnp(params: LookupParams) -> [LookupMnpJsonResponse]? {
        params.type = LookupType.mnp
        let res = client.request(endpoint: "lookup", method: "POST", payload: params)

        return try! JSONDecoder().decode([LookupMnpJsonResponse].self, from: res!)
    }
}

enum LookupType: String, Codable {
    case cnam
    case format
    case hlr
    case mnp
}

enum HlrPortedCode: String, Decodable {
    case unknown
    case ported
    case not_ported
    case assumed_not_ported
    case assumed_ported
}

enum HlrReachableCode: String, Decodable {
    case unknown
    case reachable
    case undeliverable
    case absent
    case bad_number
    case blacklisted
}

enum HlrRoamingCode: String, Decodable {
    case not_roaming
}

enum NetworkType: String, Decodable {
    case fixed_line
    case fixed_line_or_mobile
    case mobile
    case pager
    case personal_number
    case premium_rate
    case shared_cost
    case toll_free
    case uan
    case unknown
    case voicemail
    case voip
}

enum HlrStatusMessageCode: String, Decodable {
    case error
    case success
}

enum RoamingStatuscode: String, Decodable {
    case not_roaming
    case roaming
    case unknown
}

enum HlrValidNumberCode: String, Decodable {
    case unknown
    case valid
    case not_valid
}

struct LookupParams: Codable {
    var type: LookupType
    var number: String
    var json: Bool?

    init(type: LookupType, number: String) {
        self.type = type
        self.number = number
    }

    init(number: String) {
        self.number = number
    }
}

struct LookupFormatResponse: Decodable {
    var national: String
    var carrier: String
    var country_code: String
    var country_iso: String
    var country_name: String
    var international: String
    var international_formatted: String
    var network_type: NetworkType
    var success: Bool
}

struct LookupCnamResponse: Decodable {
    var code: String
    var name: String // callerID
    var number: String
    var success: String
}

struct Carrier: Decodable {
    var country: String
    var name: String
    var network_code: String
    var network_type: NetworkType
}

struct LookupHlrResponse: Decodable {
    var country_code: String
    var country_code_iso3: String?
    var country_name: String
    var country_prefix: String
    var current_carrier: Carrier
    var gsm_code: String
    var gsm_message: String
    var international_format_number: String
    var international_formatted: String
    var lookup_outcome: Int // TODO: implement Int | Bool
    var lookup_outcome_message: String
    var national_format_number: String
    var original_carrier: Carrier
    var ported: HlrPortedCode
    var reachable: HlrReachableCode
    var roaming: Roaming // TODO: implement HlrRoamingCode | Roaming
    var status: Bool
    var status_message: HlrStatusMessageCode
    var valid_number: HlrValidNumberCode
}

struct Roaming: Decodable {
    var roaming_country_code: String
    var roaming_network_code: String
    var roaming_network_name: String
    var status: RoamingStatuscode
}

struct Mnp: Decodable {
    var country: String
    var international_formatted: String
    var isPorted: Bool
    var mccmnc: String
    var national_format: String
    var network: String
    var number: String
}

struct LookupMnpJsonResponse: Decodable {
    var code: Int
    var mnp: Mnp
    var price: Float
    var success: Bool
}
