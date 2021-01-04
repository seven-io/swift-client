import Foundation
import FoundationNetworking

struct swift_client {
    var debug: Bool = false

    func makeUrl(endpoint: String) -> URL {
        URL(string: "https://gateway.sms77.io/api/" + endpoint)!
    }

    func getApiKey() -> String {
        ProcessInfo.processInfo.environment["SMS77_DUMMY_API_KEY"] ?? ""
    }

    func request(endpoint: String, method: String = "GET") -> String? {
        let group = DispatchGroup()
        group.enter()

        var response: String? = nil
        var request = URLRequest(url: makeUrl(endpoint: endpoint), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = method
        request.addValue("Basic " + getApiKey(), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if nil != data {
                response = String(decoding: data!, as: UTF8.self)
            }

            if (debug) {
                print("response: ", response as Any)
            }

            group.leave()
        }.resume()

        group.wait()

        return response
    }

    func balance() -> Float? {
        let balance = request(endpoint: "balance", method: "GET")

        return nil == balance ? nil : Float(balance!)
    }
}