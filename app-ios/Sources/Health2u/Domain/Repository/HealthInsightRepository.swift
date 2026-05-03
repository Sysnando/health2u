import Foundation

public protocol HealthInsightRepository: Sendable {
    func getHealthInsights() async -> Result<[HealthInsight], APIError>
    func getHealthInsight(id: String) async -> Result<HealthInsight, APIError>
    func observeHealthInsights() -> AsyncStream<[HealthInsight]>
}
