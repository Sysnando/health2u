import Foundation

public final class AuthInterceptor: @unchecked Sendable {
    private let apiClient: APIClient
    private let sessionStore: SessionStore

    public init(apiClient: APIClient, sessionStore: SessionStore) {
        self.apiClient = apiClient; self.sessionStore = sessionStore
    }

    public func wrapped<T: Sendable>(_ call: @Sendable () async -> Result<T, APIError>) async -> Result<T, APIError> {
        let first = await call()
        if case .failure(.unauthorized) = first {
            guard let rt = await sessionStore.refreshToken() else { return .failure(.unauthorized) }
            switch await apiClient.refresh(refreshToken: rt) {
            case .success(let resp):
                do {
                    try await sessionStore.setSession(
                        userId: resp.user.id,
                        accessToken: resp.accessToken,
                        refreshToken: resp.refreshToken
                    )
                } catch { return .failure(.unauthorized) }
                return await call()
            case .failure:
                try? await sessionStore.clear()
                return .failure(.unauthorized)
            }
        }
        return first
    }
}
