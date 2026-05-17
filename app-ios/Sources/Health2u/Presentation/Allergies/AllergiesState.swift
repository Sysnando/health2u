import Foundation

public struct AllergiesState: Equatable {
    public var allergies: [Allergy] = []
    public var isLoading = false
    public var error: String? = nil
    public var showAddSheet = false
    public var newName = ""
    public var newSeverity = ""
    public var newNotes = ""
    public var isSaving = false
    public init() {}
}
