import Foundation
import FoundationNetworking

enum InvalidArgumentError: Error {
    case emptyApiKey
}

struct Payload {
}

struct swift_client {
    var debug: Bool = false
    var sentWith: String = "Swift"
    var apiKey: String

    init(apiKey: String = ProcessInfo.processInfo.environment["SMS77_API_KEY"] ?? "") throws {
        guard !apiKey.isEmpty else {
            throw InvalidArgumentError.emptyApiKey
        }

        self.apiKey = apiKey
    }

    private func request<V>(endpoint: String, method: String = "GET", payload: V?) -> Data? where V: Encodable {
        let isGET = "GET" == method
        let hasPayload = nil != payload
        let group = DispatchGroup()
        group.enter()

        var body: Data? = nil
        var response: Data? = nil
        var to = "https://gateway.sms77.io/api/" + endpoint

        if hasPayload {
            let children = Mirror(reflecting: payload!).children
            if !children.isEmpty {
                var p: [String: String] = [:]

                if isGET {
                    to += "?"
                }

                var i = 0
                for child in children {
                    var value = child.value

                    if nil != child.label {
                        let label = child.label!

                        if value is Bool {
                            value = false == value as! Bool ? 0 : 1
                        }

                        value = "\(value)"

                        if "nil" != value as! String {
                            if isGET {
                                to += "\(0 == i ? "" : "&")\(label)=\(value)"
                            } else {
                                p[label] = (value as! String)
                            }
                        }
                    }

                    i += 1
                }

                if !p.isEmpty {
                    body = try! JSONEncoder().encode(p)
                }
            }
        }
        print("to: \(to)")
        if nil != body {
            print("body: ", body as Any)
        }
        var request = URLRequest(url: URL(string: to)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = method
        request.addValue("Basic " + ProcessInfo.processInfo.environment["SMS77_DUMMY_API_KEY"]!,
                forHTTPHeaderField: "Authorization")
        request.addValue(sentWith, forHTTPHeaderField: "sentWith")
        if nil != body {
            request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, res, error in
            response = data

            if nil != error {
                print("error: ", error as Any)
                print("res: ", res as Any)
            }

            if debug {
                print("response: ", response as Any)
            }

            group.leave()
        }.resume()

        group.wait()

        return response
    }

    public func analytics(params: AnalyticsParams) -> [AnalyticBase]? {
        let analytics = request(endpoint: "analytics", method: "GET", payload: params)

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
        struct BalanceParams: Encodable {
        }

        let balance = request(endpoint: "balance", method: "GET", payload: BalanceParams())

        return nil == balance ? nil : Float(String(decoding: balance!, as: UTF8.self))
    }

    public func contacts(params: ContactsParams) -> Any? {
        let response = request(endpoint: "contacts", method: ContactsAction.del == params.action ? "POST" : "GET",
                payload: params)

        if (nil == response) {
            return nil
        }

        if (true != params.json) {
            return String(decoding: response!, as: UTF8.self)
        }

        switch params.action {
        case .read:
            return try! JSONDecoder().decode([Contact].self, from: response!)
        case .write:
            return try! JSONDecoder().decode(ContactsWriteResponse.self, from: response!)
        case .del:
            return try! JSONDecoder().decode(ContactsWriteResponse.self, from: response!)
        }
    }
}