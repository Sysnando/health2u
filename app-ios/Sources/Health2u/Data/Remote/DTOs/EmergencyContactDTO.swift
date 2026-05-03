import Foundation

public struct EmergencyContactDTO: Codable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public let name: String
    public let relationship: String
    public let phone: String
    public let email: String?
    public let isPrimary: Bool
    public let order: Int

    public init(
        id: String,
        userId: String,
        name: String,
        relationship: String,
        phone: String,
        email: String? = nil,
        isPrimary: Bool,
        order: Int
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.relationship = relationship
        self.phone = phone
        self.email = email
        self.isPrimary = isPrimary
        self.order = order
    }
}
