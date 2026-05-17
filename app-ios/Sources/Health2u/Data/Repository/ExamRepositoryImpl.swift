import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "ExamRepo")

public final class ExamRepositoryImpl: ExamRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getExams(filter: String?) async -> Result<[Exam], APIError> {
        log.info("📋 [Repo] getExams(filter: \(filter ?? "nil"))")
        switch await apiClient.getExams(filter: filter) {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(exams: domains.map { $0.toEntity() })
            log.info("📋 [Repo] getExams → API returned \(dtos.count) DTOs, mapped to \(domains.count) domain, cached")
            for d in domains.prefix(10) {
                log.debug("📋 [Repo]   • \(d.id) | '\(d.title)' | type='\(d.type)' | date=\(d.date.timeIntervalSince1970)")
            }
            return .success(domains)
        case .failure(let error):
            let cached = await database.allExams().map { $0.toDomain() }
            if !cached.isEmpty {
                log.warning("📋 [Repo] getExams → API failed (\(String(describing: error))), returning \(cached.count) cached")
                return .success(cached)
            }
            log.error("📋 [Repo] getExams → API failed, NO cache: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func getExam(id: String) async -> Result<Exam, APIError> {
        log.info("📋 getExam(id: \(id))")
        switch await apiClient.getExam(id: id) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(exam: domain.toEntity())
            log.info("📋 getExam → fetched from API: \(domain.title)")
            return .success(domain)
        case .failure(let error):
            if let cached = await database.getExam(id: id) {
                log.warning("📋 getExam → API failed, returning cached: \(cached.title)")
                return .success(cached.toDomain())
            }
            log.error("📋 getExam → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func uploadExam(metadata: ExamUploadMetadata, fileData: Data, filename: String) async -> Result<Exam, APIError> {
        log.info("📤 uploadExam: \(metadata.title) (\(filename), \(fileData.count) bytes)")
        switch await apiClient.uploadExam(metadata: metadata, fileData: fileData, filename: filename) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(exam: domain.toEntity())
            log.info("📤 uploadExam → success, id: \(domain.id)")
            return .success(domain)
        case .failure(let error):
            log.error("📤 uploadExam → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func getExamFileURL(id: String) async -> Result<URL, APIError> {
        log.info("📎 getExamFileURL(id: \(id))")
        return await apiClient.getExamFile(id: id)
    }

    public func deleteExam(id: String) async -> Result<Void, APIError> {
        log.info("🗑️ deleteExam(id: \(id))")
        switch await apiClient.deleteExam(id: id) {
        case .success:
            await database.deleteExam(id: id)
            log.info("🗑️ deleteExam → success")
            return .success(())
        case .failure(let error):
            log.error("🗑️ deleteExam → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func reanalyzeExam(id: String) async -> Result<Exam, APIError> {
        log.info("🤖 reanalyzeExam(id: \(id))")
        switch await apiClient.reanalyzeExam(id: id) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(exam: domain.toEntity())
            log.info("🤖 reanalyzeExam → success, status: \(domain.analysis?.status.rawValue ?? "nil")")
            return .success(domain)
        case .failure(let error):
            log.error("🤖 reanalyzeExam → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func observeExams() -> AsyncStream<[Exam]> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allExams().map { $0.toDomain() }
                log.debug("📋 observeExams → emitting \(current.count) cached exams")
                continuation.yield(current)
                continuation.finish()
            }
        }
    }
}
