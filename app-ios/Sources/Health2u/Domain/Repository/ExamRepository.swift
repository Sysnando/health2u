import Foundation

public struct ExamUploadMetadata: Sendable, Equatable {
    public let title: String
    public let type: String
    public let date: Date
    public let notes: String?

    public init(title: String, type: String, date: Date, notes: String? = nil) {
        self.title = title
        self.type = type
        self.date = date
        self.notes = notes
    }
}

public protocol ExamRepository: Sendable {
    func getExams(filter: String?) async -> Result<[Exam], APIError>
    func getExam(id: String) async -> Result<Exam, APIError>
    func uploadExam(metadata: ExamUploadMetadata, fileData: Data, filename: String) async -> Result<Exam, APIError>
    func getExamFileURL(id: String) async -> Result<URL, APIError>
    func deleteExam(id: String) async -> Result<Void, APIError>
    func observeExams() -> AsyncStream<[Exam]>
}
