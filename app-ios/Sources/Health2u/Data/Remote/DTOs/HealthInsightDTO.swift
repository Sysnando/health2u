import Foundation

public struct HealthInsightsResponseDTO: Codable, Equatable, Sendable {
    public let insights: [HealthInsightDTO]

    public init(insights: [HealthInsightDTO]) {
        self.insights = insights
    }
}

public struct HealthInsightDTO: Codable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public let type: String
    public let title: String
    public let description: String
    public let metricValue: Double?
    public let timestamp: Date
    public let createdAt: Date

    public init(
        id: String,
        userId: String,
        type: String,
        title: String,
        description: String,
        metricValue: Double? = nil,
        timestamp: Date,
        createdAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.title = title
        self.description = description
        self.metricValue = metricValue
        self.timestamp = timestamp
        self.createdAt = createdAt
    }
}
