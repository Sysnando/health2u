import Foundation

public struct EmergencyContactsState: Equatable {
    public var contacts: [EmergencyContact] = []
    public var isLoading: Bool = false
    public var error: String? = nil
    public var showAddSheet: Bool = false
    public var newName: String = ""
    public var newRelationship: String = ""
    public var newPhone: String = ""
    public var newEmail: String = ""
    public var isSaving: Bool = false

    public init() {}
}
