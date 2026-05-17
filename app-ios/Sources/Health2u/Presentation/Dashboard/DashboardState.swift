import Foundation

public struct ExamBiomarker: Equatable, Sendable {
    public let kind: Kind
    public let value: String
    public let unit: String?
    public let flag: String?
    public let sourceExamId: String
    public let examDate: Date

    public enum Kind: String, Sendable, Equatable {
        case bloodSugar
        case cholesterol
        case bloodPressure
        case heartRate
        case spo2
    }

    public init(
        kind: Kind,
        value: String,
        unit: String?,
        flag: String?,
        sourceExamId: String,
        examDate: Date
    ) {
        self.kind = kind
        self.value = value
        self.unit = unit
        self.flag = flag
        self.sourceExamId = sourceExamId
        self.examDate = examDate
    }
}

public struct DashboardState: Equatable {
    public var userName: String = ""
    public var isLoading = false
    public var error: String? = nil
    public var latestBiomarkers: [ExamBiomarker.Kind: ExamBiomarker] = [:]
    public init() {}
}
