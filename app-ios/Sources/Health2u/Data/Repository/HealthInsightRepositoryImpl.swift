import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "InsightRepo")

public final class HealthInsightRepositoryImpl: HealthInsightRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getHealthInsights() async -> Result<[HealthInsight], APIError> {
        log.info("💡 getHealthInsights")
        switch await apiClient.getInsights() {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(insights: domains.map { $0.toEntity() })
            log.info("💡 getHealthInsights → \(domains.count) from API")
            return .success(domains)
        case .failure(let error):
            let cached = await database.allInsights().map { $0.toDomain() }
            if !cached.isEmpty {
                log.warning("💡 getHealthInsights → API failed, returning \(cached.count) cached")
                return .success(cached)
            }
            log.error("💡 getHealthInsights → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func getHealthInsight(id: String) async -> Result<HealthInsight, APIError> {
        if let cached = await database.getInsight(id: id) {
            return .success(cached.toDomain())
        }
        return .failure(.invalidResponse)
    }

    public func observeHealthInsights() -> AsyncStream<[HealthInsight]> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allInsights().map { $0.toDomain() }
                continuation.yield(current)
                continuation.finish()
            }
        }
    }
}
