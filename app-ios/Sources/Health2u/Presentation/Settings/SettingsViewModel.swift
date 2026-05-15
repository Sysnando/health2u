import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "SettingsVM")

@MainActor
public final class SettingsViewModel: ObservableObject {
    @Published public var state = SettingsState()

    private let authRepository: any AuthRepository

    public init(authRepository: any AuthRepository) {
        self.authRepository = authRepository
    }

    public func load() async {
        // Settings loaded from local preferences (placeholder)
    }

    public func logout() async -> Bool {
        log.info("🚪 Logout initiated from settings")
        state.isLoggingOut = true
        state.error = nil

        let result = await authRepository.logout()

        state.isLoggingOut = false

        switch result {
        case .success:
            log.info("🚪 Logout succeeded")
            return true
        case .failure(let err):
            log.error("🚪 Logout failed: \(String(describing: err))")
            state.error = Self.errorMessage(err)
            return false
        }
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Failed to sign out."
        }
    }
}
