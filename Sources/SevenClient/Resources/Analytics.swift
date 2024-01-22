import Foundation

struct ApiParams: Codable {
    let group_by: String
    
    init(group_by: AnalyticsGroupBy, params: AnalyticsParams) {
        self.group_by = group_by
        self.end = params.end
        self.label = params.label
        self.start = params.start
        self.subaccounts = params.subaccounts
    }
}

struct Analytics {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    private func request(group_by: AnalyticsGroupBy, params: AnalyticsParams) -> [AnalyticBase]? {
        let params = ApiParams(group_by, params)
        return client.request(endpoint: "analytics", method: "GET", payload: params)
    }

    public func byDate(params: AnalyticsParams) -> [AnalyticGroupByDate]? {
        let res = request(AnalyticsGroupBy.date, params)

        return try! JSONDecoder().decode([AnalyticGroupByDate].self, from: res!)
    }

    public func byLabel(params: AnalyticsParams) -> [AnalyticGroupByLabel]? {
        let res = request(AnalyticsGroupBy.label, params)

        return try! JSONDecoder().decode([AnalyticGroupByLabel].self, from: res!)
    }

    public func bySubaccount(params: AnalyticsParams) -> [AnalyticGroupBySubaccount]? {
        let res = request(AnalyticsGroupBy.subaccount, params)

        return try! JSONDecoder().decode([AnalyticGroupBySubaccount].self, from: res!)
    }

    public func byCountry(params: AnalyticsParams) -> [AnalyticGroupByCountry]? {
        let res = request(AnalyticsGroupBy.country, params)

        return try! JSONDecoder().decode([AnalyticGroupByCountry].self, from: res!)
    }
}

enum AnalyticsGroupBy: String, Codable {
    case date
    case label
    case subaccount
    case country
}

struct AnalyticsParams: Codable {
    var end: String?
    // var group_by: AnalyticsGroupBy = AnalyticsGroupBy.date
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
