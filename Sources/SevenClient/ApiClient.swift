import Foundation

enum InvalidArgumentError: Error {
    case emptyApiKey
}

struct ApiClient {

    var apiKey: String
    var debug: Bool = false
    var sentWith: String = "Swift"

    init(apiKey: String = ProcessInfo.processInfo.environment["SEVEN_API_KEY"] ?? "") throws {
        guard !apiKey.isEmpty else {
            throw InvalidArgumentError.emptyApiKey
        }

        self.apiKey = apiKey
    }

    public func request<V>(endpoint: String, method: String = "GET", payload: V?) -> Data? where V: Codable {
        let hasPayload = nil != payload
        let group = DispatchGroup()
        group.enter()

        var response: Data? = nil
        var to = "https://gateway.seven.io/api/" + endpoint

        if hasPayload {
            let encodedPayload = try! JSONEncoder().encode(payload)
            let children = Mirror(reflecting: try! JSONDecoder().decode(V.self, from: encodedPayload)).children
            if !children.isEmpty {
                to += "?"

                let p: [String: String] = [:]
                var args = 0
                for child in children {
                    var value = child.value

                    if nil != child.label {
                        let label = child.label!

                        if value is Bool {
                            value = false == value as! Bool ? 0 : 1
                        }

                        value = "\(value)"

                        if value is String {
                            value = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                        }

                        if "nil" != value as! String {
                            to += "\(0 == args ? "" : "&")\(label)=\(value)"

                            args += 1
                        }
                    }

                }
            }
        }

        print("to: \(to)")

        var request = URLRequest(url: URL(string: to)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = method
        request.addValue("Basic \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue(sentWith, forHTTPHeaderField: "sentWith")

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
}
