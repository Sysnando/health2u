import Foundation

public struct UserEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var email: String
    public var name: String
    public var profilePictureUrl: String?
    public var dateOfBirth: Date?
    public var phone: String?
    public var gender: String?
    public var heightCm: Double?
    public var weightKg: Double?
    public var bloodType: String?
    public var lastSyncTimestamp: Date

    public init(
        id: String,
        email: String,
        name: String,
        profilePictureUrl: String? = nil,
        dateOfBirth: Date? = nil,
        phone: String? = nil,
        gender: String? = nil,
        heightCm: Double? = nil,
        weightKg: Double? = nil,
        bloodType: String? = nil,
        lastSyncTimestamp: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.profilePictureUrl = profilePictureUrl
        self.dateOfBirth = dateOfBirth
        self.phone = phone
        self.gender = gender
        self.heightCm = heightCm
        self.weightKg = weightKg
        self.bloodType = bloodType
        self.lastSyncTimestamp = lastSyncTimestamp
    }
}
