import Foundation

enum AnalyticsGroupBy: String {
    case date = "date"
    case label = "label"
    case subaccount = "subaccount"
    case country = "country"
}

struct AnalyticsParams: Encodable {
    var end: String?
    var group_by: AnalyticsGroupBy = AnalyticsGroupBy.date
    var label: String?
    var start: String?
    var subaccounts: String?

    func encode(to encoder: Encoder) throws {}
}

protocol AnalyticBase: Codable {
    var direct: Int? { get set }
    var economy: Int? { get set }
    var hlr: Int? { get set }
    var inbound: Int? { get set }
    var mnp: Int? { get set }
    var usage_eur: Float? { get set }
    var voice: Int? { get set }
}

struct AnalyticGroupByCountry: AnalyticBase {
    var direct: Int?
    var economy: Int?
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var usage_eur: Float?
    var voice: Int?
    var country: String
}

struct AnalyticGroupByDate: AnalyticBase {
    var direct: Int?
    var economy: Int?
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var usage_eur: Float?
    var voice: Int?
    var date: String
}

struct AnalyticGroupBySubaccount: AnalyticBase {
    var direct: Int?
    var economy: Int?
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var usage_eur: Float?
    var voice: Int?
    var account: String
}

struct AnalyticGroupByLabel: AnalyticBase {
    var direct: Int?
    var economy: Int?
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var usage_eur: Float?
    var voice: Int?
    var label: String
}