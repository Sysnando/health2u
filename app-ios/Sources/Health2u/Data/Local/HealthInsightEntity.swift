import Foundation

public struct HealthInsightEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var userId: String
    public var type: String
    public var title: String
    public var descriptionText: String
    public var metricValue: Double?
    public var timestamp: Date
    public var createdAt: Date

    public init(
        id: String,
        userId: String,
        type: String,
        title: String,
        descriptionText: String,
        metricValue: Double? = nil,
        timestamp: Date,
        createdAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.descriptionText = descriptionText
        self.metricValue = metricValue
        self.timestamp = timestamp
        self.createdAt = createdAt
    }
}
