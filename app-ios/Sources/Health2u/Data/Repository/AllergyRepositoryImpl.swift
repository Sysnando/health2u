import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "AllergyRepo")

public final class AllergyRepositoryImpl: AllergyRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getAllergies() async -> Result<[Allergy], APIError> {
        log.info("getAllergies")
        switch await apiClient.getAllergies() {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(allergies: domains.map { $0.toEntity() })
            log.info("getAllergies → \(domains.count) from API")
            return .success(domains)
        case .failure(let error):
            let cached = await database.allAllergies().map { $0.toDomain() }
            if !cached.isEmpty {
                log.warning("getAllergies → API failed, returning \(cached.count) cached")
                return .success(cached)
            }
            log.error("getAllergies → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func createAllergy(name: String, severity: String?, notes: String?) async -> Result<Allergy, APIError> {
        switch await apiClient.createAllergy(name: name, severity: severity, notes: notes) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(allergy: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func updateAllergy(id: String, name: String?, severity: String?, notes: String?) async -> Result<Allergy, APIError> {
        switch await apiClient.updateAllergy(id: id, name: name, severity: severity, notes: notes) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(allergy: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func deleteAllergy(id: String) async -> Result<Void, APIError> {
        switch await apiClient.deleteAllergy(id: id) {
        case .success:
            await database.deleteAllergy(id: id)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
