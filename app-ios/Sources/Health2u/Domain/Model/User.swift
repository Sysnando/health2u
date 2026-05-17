import Foundation

public struct User: Identifiable, Equatable, Sendable {
    public let id: String
    public let email: String
    public let name: String
    public let profilePictureUrl: String?
    public let dateOfBirth: Date?
    public let phone: String?
    public let gender: String?
    public let heightCm: Double?
    public let weightKg: Double?
    public let bloodType: String?
    public let hasDiabetes: Bool?
    public let hasAllergies: Bool?

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
        hasDiabetes: Bool? = nil,
        hasAllergies: Bool? = nil
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
        self.hasDiabetes = hasDiabetes
        self.hasAllergies = hasAllergies
    }
}
