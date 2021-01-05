enum ContactsAction: String {
    case del = "del"
    case read = "read"
    case write = "write"
}

struct ContactsParams: Encodable {
    let action: ContactsAction

    var email: String?
    var empfaenger: String?
    var id: Int?
    var json: Bool?
    var nick: String?

    init(action: ContactsAction) {
        self.action = action
    }

    func encode(to encoder: Encoder) throws {
    }
}

struct ContactsWriteResponse: Decodable {
    var `return`: String
    var id: String
}

struct Contact: Decodable {
    var email: String?
    var id: Int?
    var ID: String?
    var Name: String?
    var number: String?
    var Number: String?
    var nick: String?
}
