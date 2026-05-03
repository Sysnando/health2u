import Foundation

extension HealthInsightDTO {
    public func toDomain() -> HealthInsight {
        HealthInsight(
            id: id,
            userId: userId,
            type: type,
            title: title,
            description: description,
            metricValue: metricValue,
            timestamp: timestamp,
            createdAt: createdAt
        )
    }
}

extension HealthInsight {
    public func toDTO() -> HealthInsightDTO {
        HealthInsightDTO(
            id: id,
            userId: userId,
            type: type,
            title: title,
            description: description,
            metricValue: metricValue,
            timestamp: timestamp,
            createdAt: createdAt
        )
    }

    public func toEntity() -> HealthInsightEntity {
        HealthInsightEntity(
            id: id,
            userId: userId,
            type: type,
            title: title,
            descriptionText: description,
            metricValue: metricValue,
            timestamp: timestamp,
            createdAt: createdAt
        )
    }
}

extension HealthInsightEntity {
    public func toDomain() -> HealthInsight {
        HealthInsight(
            id: id,
            userId: userId,
            type: type,
            title: title,
            description: descriptionText,
            metricValue: metricValue,
            timestamp: timestamp,
            createdAt: createdAt
        )
    }
}
