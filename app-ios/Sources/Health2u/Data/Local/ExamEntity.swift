import Foundation

public struct ExamEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var userId: String
    public var title: String
    public var type: String
    public var date: Date
    public var fileUrl: String?
    public var localFilePath: String?
    public var notes: String?
    public var createdAt: Date
    public var updatedAt: Date
    public var analysis: ExamAnalysisEntity?

    public init(
        id: String,
        userId: String,
        title: String,
        type: String,
        date: Date,
        fileUrl: String? = nil,
        localFilePath: String? = nil,
        notes: String? = nil,
        createdAt: Date,
        updatedAt: Date,
        analysis: ExamAnalysisEntity? = nil
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.type = type
        self.date = date
        self.fileUrl = fileUrl
        self.localFilePath = localFilePath
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.analysis = analysis
    }
}
