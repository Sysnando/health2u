import Foundation

public final class UserRepositoryImpl: UserRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getProfile() async -> Result<User, APIError> {
        switch await apiClient.getProfile() {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            let cached = await database.allUsers().first.map { $0.toDomain() }
            if let cached { return .success(cached) }
            return .failure(error)
        }
    }

    public func updateProfile(_ user: User) async -> Result<User, APIError> {
        switch await apiClient.updateProfile(user.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func uploadProfilePhoto(imageData: Data, filename: String) async -> Result<User, APIError> {
        switch await apiClient.uploadProfilePhoto(imageData: imageData, filename: filename) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func observeProfile() -> AsyncStream<User?> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allUsers().first.map { $0.toDomain() }
                continuation.yield(current)
                continuation.finish()
            }
        }
    }

    public func logout() async -> Result<Void, APIError> {
        switch await apiClient.logout() {
        case .success:
            await database.clear()
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}
