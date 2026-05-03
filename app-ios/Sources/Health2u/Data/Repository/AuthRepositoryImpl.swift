import Foundation

public final class AuthRepositoryImpl: AuthRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let sessionStore: SessionStore

    public init(apiClient: APIClient, sessionStore: SessionStore) {
        self.apiClient = apiClient; self.sessionStore = sessionStore
    }

    public func login(email: String, password: String) async -> Result<Void, APIError> {
        switch await apiClient.login(email: email, password: password) {
        case .success(let resp):
            do {
                try await sessionStore.setSession(
                    userId: resp.user.id,
                    accessToken: resp.accessToken,
                    refreshToken: resp.refreshToken
                )
                return .success(())
            } catch { return .failure(.invalidResponse) }
        case .failure(let err): return .failure(err)
        }
    }

    public func refreshIfNeeded() async -> Result<Void, APIError> {
        guard let rt = await sessionStore.refreshToken() else { return .failure(.unauthorized) }
        switch await apiClient.refresh(refreshToken: rt) {
        case .success(let resp):
            do {
                try await sessionStore.setSession(
                    userId: resp.user.id,
                    accessToken: resp.accessToken,
                    refreshToken: resp.refreshToken
                )
                return .success(())
            } catch { return .failure(.invalidResponse) }
        case .failure(let err): return .failure(err)
        }
    }

    public func logout() async -> Result<Void, APIError> {
        _ = await apiClient.logout()
        do { try await sessionStore.clear(); return .success(()) }
        catch { return .failure(.invalidResponse) }
    }

    public func isAuthenticated() async -> Bool { await sessionStore.isAuthenticated() }
}
