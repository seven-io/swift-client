enum AnalyticsGroupBy {
    case date
    case label
    case subaccount
    case country
}

public struct AnalyticsParams {
    var end: String?
    var group_by: AnalyticsGroupBy
    var label: String?
    var start: String?
    var subaccounts: String?

    init(group_by: AnalyticsGroupBy = AnalyticsGroupBy.date) {
        self.group_by = group_by
    }
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