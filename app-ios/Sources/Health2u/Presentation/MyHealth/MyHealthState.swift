import Foundation

public struct HealthYear: Identifiable, Equatable, Sendable {
    public let year: Int
    public let examCount: Int
    public let color: HealthColor
    public let aiAnalyzedCount: Int
    public var id: Int { year }

    public init(year: Int, examCount: Int, color: HealthColor, aiAnalyzedCount: Int = 0) {
        self.year = year
        self.examCount = examCount
        self.color = color
        self.aiAnalyzedCount = aiAnalyzedCount
    }
}

public enum HealthColor: Equatable, Sendable {
    case green, yellow, red

    public var systemColor: String {
        switch self {
        case .green: return "checkmark.circle.fill"
        case .yellow: return "exclamationmark.circle.fill"
        case .red: return "xmark.circle.fill"
        }
    }
}

public struct MyHealthState: Equatable {
    public var years: [HealthYear] = []
    public var isLoading = false
    public var error: String? = nil
    public init() {}
}
