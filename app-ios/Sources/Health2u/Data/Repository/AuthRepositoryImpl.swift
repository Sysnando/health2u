import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "AuthRepo")

public final class AuthRepositoryImpl: AuthRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let sessionStore: SessionStore

    public init(apiClient: APIClient, sessionStore: SessionStore) {
        self.apiClient = apiClient; self.sessionStore = sessionStore
    }

    public func login(email: String, password: String) async -> Result<Void, APIError> {
        log.info("🔐 AuthRepo.login for \(email)")
        switch await apiClient.login(email: email, password: password) {
        case .success(let resp):
            do {
                try await sessionStore.setSession(
                    userId: resp.user.id,
                    accessToken: resp.accessToken,
                    refreshToken: resp.refreshToken
                )
                log.info("🔐 AuthRepo.login succeeded, session stored")
                return .success(())
            } catch {
                log.error("🔐 AuthRepo.login succeeded but session save failed")
                return .failure(.invalidResponse)
            }
        case .failure(let err):
            log.error("🔐 AuthRepo.login failed: \(String(describing: err))")
            return .failure(err)
        }
    }

    public func refreshIfNeeded() async -> Result<Void, APIError> {
        guard let rt = await sessionStore.refreshToken() else {
            log.warning("🔄 AuthRepo.refreshIfNeeded — no refresh token")
            return .failure(.unauthorized)
        }
        log.info("🔄 AuthRepo.refreshIfNeeded — attempting refresh")
        switch await apiClient.refresh(refreshToken: rt) {
        case .success(let resp):
            do {
                try await sessionStore.setSession(
                    userId: resp.user.id,
                    accessToken: resp.accessToken,
                    refreshToken: resp.refreshToken
                )
                log.info("🔄 AuthRepo.refreshIfNeeded succeeded")
                return .success(())
            } catch { return .failure(.invalidResponse) }
        case .failure(let err):
            log.error("🔄 AuthRepo.refreshIfNeeded failed: \(String(describing: err))")
            return .failure(err)
        }
    }

    public func logout() async -> Result<Void, APIError> {
        log.info("🚪 AuthRepo.logout")
        _ = await apiClient.logout()
        do {
            try await sessionStore.clear()
            log.info("🚪 AuthRepo.logout — session cleared")
            return .success(())
        }
        catch {
            log.error("🚪 AuthRepo.logout — failed to clear session")
            return .failure(.invalidResponse)
        }
    }

    public func isAuthenticated() async -> Bool { await sessionStore.isAuthenticated() }
}
