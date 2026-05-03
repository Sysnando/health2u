import Foundation

public struct InsightsState: Equatable {
    public var insights: [HealthInsight] = []
    public var isLoading: Bool = false
    public var error: String? = nil

    public init() {}
}
