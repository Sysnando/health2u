import Foundation

public struct AllergyEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var userId: String
    public var name: String
    public var severity: String?
    public var notes: String?
    public var createdAt: Date

    public init(id: String, userId: String, name: String, severity: String? = nil, notes: String? = nil, createdAt: Date = Date()) {
        self.id = id; self.userId = userId; self.name = name; self.severity = severity; self.notes = notes; self.createdAt = createdAt
    }
}
