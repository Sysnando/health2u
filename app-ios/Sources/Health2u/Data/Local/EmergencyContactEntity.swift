import Foundation

public struct EmergencyContactEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var userId: String
    public var name: String
    public var relationship: String
    public var phone: String
    public var email: String?
    public var isPrimary: Bool
    public var order: Int

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
