import Foundation

public final class ExamRepositoryImpl: ExamRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getExams(filter: String?) async -> Result<[Exam], APIError> {
        switch await apiClient.getExams(filter: filter) {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(exams: domains.map { $0.toEntity() })
            return .success(domains)
        case .failure(let error):
            let cached = await database.allExams().map { $0.toDomain() }
            if !cached.isEmpty { return .success(cached) }
            return .failure(error)
        }
    }

    public func getExam(id: String) async -> Result<Exam, APIError> {
        switch await apiClient.getExam(id: id) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(exam: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            if let cached = await database.getExam(id: id) {
                return .success(cached.toDomain())
            }
            return .failure(error)
        }
    }

    public func uploadExam(metadata: ExamUploadMetadata, fileData: Data, filename: String) async -> Result<Exam, APIError> {
        switch await apiClient.uploadExam(metadata: metadata, fileData: fileData, filename: filename) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(exam: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func getExamFileURL(id: String) async -> Result<URL, APIError> {
        return await apiClient.getExamFile(id: id)
    }

    public func deleteExam(id: String) async -> Result<Void, APIError> {
        switch await apiClient.deleteExam(id: id) {
        case .success:
            await database.deleteExam(id: id)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    public func observeExams() -> AsyncStream<[Exam]> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allExams().map { $0.toDomain() }
                continuation.yield(current)
                continuation.finish()
            }
        }
    }
}
