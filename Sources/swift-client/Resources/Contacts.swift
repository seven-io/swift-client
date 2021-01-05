struct ContactsParams: Codable {
    let action: ContactsAction

    var email: String?
    var empfaenger: String?
    var id: Int?
    var json: Bool?
    var nick: String?

    init(action: ContactsAction) {self.action = action}
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
    var email: String?
    var id: Int?
    var ID: String?
    var Name: String?
    var number: String?
    var Number: String?
    var nick: String?
}
