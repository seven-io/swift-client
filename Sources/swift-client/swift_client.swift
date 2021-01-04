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

    func balance() -> Float? {
        let group = DispatchGroup()
        group.enter()

        var balance: Float? = nil
        var request = URLRequest(url: makeUrl(endpoint: "balance"), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.addValue("Basic " + getApiKey(), forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if nil != data {
                balance = Float(String(decoding: data!, as: UTF8.self))
            }

            if (debug) {
                print("balance: ", balance as Any)
            }

            group.leave()
        }.resume()


        group.wait()

        return balance
    }
}