import Foundation

public final class EmergencyContactRepositoryImpl: EmergencyContactRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getEmergencyContacts() async -> Result<[EmergencyContact], APIError> {
        switch await apiClient.getEmergencyContacts() {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(contacts: domains.map { $0.toEntity() })
            return .success(domains)
        case .failure(let error):
            let cached = await database.allContacts().map { $0.toDomain() }
            if !cached.isEmpty { return .success(cached) }
            return .failure(error)
        }
    }

    public func getEmergencyContact(id: String) async -> Result<EmergencyContact, APIError> {
        if let cached = await database.getContact(id: id) {
            return .success(cached.toDomain())
        }
        return .failure(.invalidResponse)
    }

    public func addEmergencyContact(_ contact: EmergencyContact) async -> Result<EmergencyContact, APIError> {
        switch await apiClient.createEmergencyContact(contact.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(contact: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func updateEmergencyContact(_ contact: EmergencyContact) async -> Result<EmergencyContact, APIError> {
        switch await apiClient.updateEmergencyContact(id: contact.id, contact.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(contact: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func deleteEmergencyContact(id: String) async -> Result<Void, APIError> {
        switch await apiClient.deleteEmergencyContact(id: id) {
        case .success:
            await database.deleteContact(id: id)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    public func observeEmergencyContacts() -> AsyncStream<[EmergencyContact]> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allContacts().map { $0.toDomain() }
                continuation.yield(current)
                continuation.finish()
            }
        }
    }
}
