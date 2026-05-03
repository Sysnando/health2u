import Foundation

@MainActor
public final class InsightsViewModel: ObservableObject {
    @Published public var state = InsightsState()

    private let healthInsightRepository: any HealthInsightRepository

    public init(healthInsightRepository: any HealthInsightRepository) {
        self.healthInsightRepository = healthInsightRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await healthInsightRepository.getHealthInsights()

        switch result {
        case .success(let insights):
            state.insights = insights
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Failed to load insights."
        }
    }
}
