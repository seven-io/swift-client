struct ContactsDeleteResponse: Decodable {
    var `return`: String
}

struct ContactsCreateResponse: Decodable {
    var id: Int
    var `return`: String
}

struct ContactsEditParams: Codable {
    var action: String
    var email: String?
    var empfaenger: String?
    var id: Int
    var nick: String?

    init(id: Int) {
        self.action = "write"
        self.id = id
    }
}


struct Contacts {
    var client: ApiClient

    init(client: ApiClient) {
        self.client = client
    }

    public func read(id: Int?) -> [Contact]? {
        struct Params: Codable {
            let action: String
            let id: Int?
            
            init(id: Int?) {
                self.action = "read"
                self.id = id
            }
        }
        let params = Params()
        let res = client.request(endpoint: "contacts", method: "GET", payload: params)

        return try! JSONDecoder().decode([Contact].self, from: res!)
    }

    public func delete(id: Int) -> ContactsDeleteResponse? {
        struct Params: Codable {
            let action: String
            let id: Int
            
            init() {
                self.action = "del"
                self.id = id
            }
        }
        let params = Params()
        let res = client.request(endpoint: "contacts", method: "POST", payload: params)

        return try! JSONDecoder().decode(ContactsDeleteResponse.self, from: res!)
    }

    public func create(id: Int) -> ContactsCreateResponse? {
        struct Params: Codable {
            let action: String
            let id: Int
            
            init() {
                self.action = "write"
                self.id = id
            }
        }
        let params = Params()
        let res = client.request(endpoint: "contacts", method: "POST", payload: params)

        return try! JSONDecoder().decode(ContactsCreateResponse.self, from: res!)
    }

    public func edit(params: ContactsEditParams) -> ContactsCreateResponse? {
        let res = client.request(endpoint: "contacts", method: "POST", payload: params)

        return try! JSONDecoder().decode(ContactsCreateResponse.self, from: res!)
    }
}

struct ContactsParams: Codable {
    let action: ContactsAction

    var email: String?
    var empfaenger: String?
    var id: Int?
    var json: Bool?
    var nick: String?

    init(action: ContactsAction) {
        self.action = action
    }
}

enum ContactsAction: String, Codable {
    case del
    case read
    case write
}

struct ContactsWriteResponse: Decodable {
    var `return`: String
    var id: String
}

struct Contact: Decodable {
    // var email: String?
    // var id: Int?
    var ID: String?
    var Name: String?
    // var number: String?
    var Number: String?
    // var nick: String?
}
