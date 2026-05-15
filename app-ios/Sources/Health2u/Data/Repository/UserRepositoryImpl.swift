import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "UserRepo")

public final class UserRepositoryImpl: UserRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getProfile() async -> Result<User, APIError> {
        log.info("👤 getProfile")
        switch await apiClient.getProfile() {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            log.info("👤 getProfile → \(domain.name)")
            return .success(domain)
        case .failure(let error):
            let cached = await database.allUsers().first.map { $0.toDomain() }
            if let cached {
                log.warning("👤 getProfile → API failed, returning cached: \(cached.name)")
                return .success(cached)
            }
            log.error("👤 getProfile → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func updateProfile(_ user: User) async -> Result<User, APIError> {
        log.info("👤 updateProfile")
        switch await apiClient.updateProfile(user.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            log.info("👤 updateProfile → success")
            return .success(domain)
        case .failure(let error):
            log.error("👤 updateProfile → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func uploadProfilePhoto(imageData: Data, filename: String) async -> Result<User, APIError> {
        log.info("📷 uploadProfilePhoto (\(filename), \(imageData.count) bytes)")
        switch await apiClient.uploadProfilePhoto(imageData: imageData, filename: filename) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(user: domain.toEntity())
            log.info("📷 uploadProfilePhoto → success")
            return .success(domain)
        case .failure(let error):
            log.error("📷 uploadProfilePhoto → failed: \(String(describing: error))")
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
        log.info("🚪 UserRepo.logout — clearing database")
        switch await apiClient.logout() {
        case .success:
            await database.clear()
            log.info("🚪 UserRepo.logout → success, database cleared")
            return .success(())
        case .failure(let error):
            log.error("🚪 UserRepo.logout → failed: \(String(describing: error))")
            return .failure(error)
        }
    }
}
