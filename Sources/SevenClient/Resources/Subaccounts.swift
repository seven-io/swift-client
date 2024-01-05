import Foundation

struct Subaccounts {
        var client: ApiClient

        init(client: ApiClient) {
            self.client = client
        }

        public func read() -> [Subaccount]? {
            struct Params: Codable {
                let action: String
                
                init() {
                    self.action = "read"
                }
            }
            let params = Params()


            let res = client.request(endpoint: "subaccounts", method: "GET", payload: params)

            return try! JSONDecoder().decode([Subaccount].self, from: res!)
        }

        public func delete(params: SubaccountsDeleteParams) -> SubaccountsDeleteResponse? {
            let res = client.request(endpoint: "subaccounts", method: "POST", payload: params)

            return try! JSONDecoder().decode(SubaccountsDeleteResponse.self, from: res!)
        }

        public func create(params: SubaccountsCreateParams) -> SubaccountsCreateResponse? {
            let res = client.request(endpoint: "subaccounts", method: "POST", payload: params)

            return try! JSONDecoder().decode(SubaccountsCreateResponse.self, from: res!)
        }

        public func transferCredits(params: SubaccountsTransferCreditsParams) -> SubaccountsTransferCreditsResponse? {
            let res = client.request(endpoint: "subaccounts", method: "POST", payload: params)

            return try! JSONDecoder().decode(SubaccountsTransferCreditsResponse.self, from: res!)
        }

        public func autoCharge(params: SubaccountsAutoChargeParams) -> SubaccountsAutoChargeResponse? {
            let res = client.request(endpoint: "subaccounts", method: "POST", payload: params)

            return try! JSONDecoder().decode(SubaccountsAutoChargeResponse.self, from: res!)
        }
    }

class SubaccountsApiParams: Codable {
    let action: String
    
    init(action: String) {
        self.action = action
    }
}

struct SubaccountsCreateParams: Codable {
    let action: String
    var email: String
    var name: String

     init(email: String, name: String) {
        self.action = "create"
        self.email = email
        self.name = name
    }
}

struct SubaccountsCreateResponse: Decodable {
    var subaccount: Subaccount?
    var success: Bool
    var error: String?
}

struct SubaccountsDeleteParams: Codable {
    let action: String
    var id: Int

    init(id: Int) {
        self.action = "delete"
        self.id = id
    }
}

struct SubaccountsDeleteResponse: Decodable {
    var error: String?
    var success: Bool
}

struct SubaccountsTransferCreditsParams: Codable {
    let action: String
    var amount: Float
    var id: Int

    init(id: Int, amount: Float) {
        self.action = "transfer_credits"
        self.id = id
        self.amount = amount
    }
}

struct SubaccountsTransferCreditsResponse: Decodable {
    var error: String?
    var success: Bool
}

struct SubaccountsAutoChargeParams: Codable {
    let action: String
    var amount: Float
    var id: Int
    var threshold: Float

    init(id: Int, amount: Float, threshold: Float) {
        self.action = "update"
        self.id = id
        self.amount = amount
        self.threshold = threshold
    }
}

struct SubaccountsAutoChargeResponse: Decodable {
    var error: String?
    var success: Bool
}

struct SubaccountAutoTopup: Decodable {
    var amount: Float?
    var threshold: Float?
}

struct SubaccountContact: Decodable {
    var email: String
    var name: String
}

struct Subaccount: Decodable {
    var id: Int
    var username: String?
    var company: String?
    var balance: Float
    var total_usage: Float
    var auto_topup: SubaccountAutoTopup
    var contact: SubaccountContact
}
