import Foundation

public struct Exam: Identifiable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public let title: String
    public let type: String
    public let date: Date
    public let fileUrl: String?
    public let notes: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let analysis: ExamAnalysis?

    public init(
        id: String,
        userId: String,
        title: String,
        type: String,
        date: Date,
        fileUrl: String? = nil,
        notes: String? = nil,
        createdAt: Date,
        updatedAt: Date,
        analysis: ExamAnalysis? = nil
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.type = type
        self.date = date
        self.fileUrl = fileUrl
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.analysis = analysis
    }
}
