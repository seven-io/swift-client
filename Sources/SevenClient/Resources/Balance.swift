struct Balance {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func get() -> BalanceResponse? {
        struct BalanceParams: Codable {
        }

        let params = BalanceParams()
        let res = client.request(endpoint: "balance", method: "GET", payload: params)
        return try! JSONDecoder().decode([BalanceResponse].self, from: res!)
    }
}

struct BalanceResponse: Decodable {
    var amount: Float
    var currency: String
}