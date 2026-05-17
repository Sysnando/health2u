import Foundation

public struct Allergy: Identifiable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public let name: String
    public let severity: String?
    public let notes: String?
    public let createdAt: Date

    public init(id: String, userId: String, name: String, severity: String? = nil, notes: String? = nil, createdAt: Date) {
        self.id = id; self.userId = userId; self.name = name; self.severity = severity; self.notes = notes; self.createdAt = createdAt
    }
}
