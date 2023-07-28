import Foundation

enum AnalyticsGroupBy: String, Codable {
    case date
    case label
    case subaccount
    case country
}

struct AnalyticsParams: Codable {
    var end: String?
    var group_by: AnalyticsGroupBy = AnalyticsGroupBy.date
    var label: String?
    var start: String?
    var subaccounts: String?
}

protocol AnalyticBase: Codable {
    var hlr: Int? { get set }
    var inbound: Int? { get set }
    var mnp: Int? { get set }
    var sms: Int? { get set }
    var usage_eur: Float? { get set }
    var voice: Int? { get set }
}

struct AnalyticGroupByCountry: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var country: String
}

struct AnalyticGroupByDate: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var date: String
}

struct AnalyticGroupBySubaccount: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var account: String
}

struct AnalyticGroupByLabel: AnalyticBase {
    var hlr: Int?
    var inbound: Int?
    var mnp: Int?
    var sms: Int?
    var usage_eur: Float?
    var voice: Int?
    var label: String
}
