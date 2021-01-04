struct ContactsParams {
    let action: String

    var email: String?
    var empfaenger: String?
    var id: Int?
    var json: Bool?
    var nick: String?

    init(action: String) {
        self.action = action
    }
}
