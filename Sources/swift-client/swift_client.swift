import Foundation
import FoundationNetworking

struct swift_client {
    var debug: Bool = false

    private func request(endpoint: String, method: String = "GET") -> Data? {
        let group = DispatchGroup()
        group.enter()

        var response: Data? = nil
        var request = URLRequest(url: URL(string: "https://gateway.sms77.io/api/" + endpoint)!,
                cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = method
        request.addValue("Basic " + ProcessInfo.processInfo.environment["SMS77_DUMMY_API_KEY"]!,
                forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            response = data

            if (debug) {
                print("response: ", response as Any)
            }

            group.leave()
        }.resume()

        group.wait()

        return response
    }

    public func analytics(params: AnalyticsParams) -> [AnalyticBase]? {
        let analytics = request(endpoint: "analytics", method: "GET")

        if (nil == analytics) {
            return nil
        }

        switch params.group_by {
        case .date:
            return try! JSONDecoder().decode([AnalyticGroupByDate].self, from: analytics!)
        case .label:
            return try! JSONDecoder().decode([AnalyticGroupByLabel].self, from: analytics!)
        case .subaccount:
            return try! JSONDecoder().decode([AnalyticGroupBySubaccount].self, from: analytics!)
        case .country:
            return try! JSONDecoder().decode([AnalyticGroupByCountry].self, from: analytics!)
        }
    }

    public func balance() -> Float? {
        let balance = request(endpoint: "balance", method: "GET")

        return nil == balance ? nil : Float(String(decoding: balance!, as: UTF8.self))
    }
}