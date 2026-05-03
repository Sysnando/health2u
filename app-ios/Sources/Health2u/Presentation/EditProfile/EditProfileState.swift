import Foundation

public struct EditProfileState: Equatable {
    public var name: String = ""
    public var email: String = ""
    public var phone: String = ""
    public var dateOfBirth: Date? = nil
    public var gender: String = ""
    public var heightCm: String = ""
    public var weightKg: String = ""
    public var bloodType: String = ""
    public var userId: String = ""
    public var isLoading: Bool = false
    public var isSaving: Bool = false
    public var error: String? = nil
    public var didSave: Bool = false
    public var isUploadingPhoto: Bool = false

    public init() {}
}
