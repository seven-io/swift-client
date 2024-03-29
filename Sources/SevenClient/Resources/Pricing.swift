enum PricingFormat: String, Codable {
    case csv
    case json
}

struct PricingParams: Codable {
    var country: String?
    var format: PricingFormat?
}

struct CountryNetwork: Decodable {
    var comment: String
    var features: [String]
    var mcc: String
    var mncs: [String]
    var networkName: String
    var price: Float
}

struct CountryPricing: Decodable {
    var countryCode: String
    var countryName: String
    var countryPrefix: String
    var networks: [CountryNetwork]
}

struct PricingResponse: Decodable {
    var countCountries: Int
    var countNetworks: Int
    var countries: [CountryPricing]
}
