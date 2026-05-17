import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "LoginVM")

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var state = LoginState()
    private let authRepository: AuthRepository

    public init(authRepository: AuthRepository) { self.authRepository = authRepository }

    public func signIn() async {
        guard !state.email.isEmpty, !state.password.isEmpty else {
            log.warning("🔐 Sign in blocked — empty email or password")
            state.error = "Email and password are required."; return
        }
        log.info("🔐 Sign in started for \(self.state.email)")
        state.isLoading = true; state.error = nil
        let result = await authRepository.login(email: state.email, password: state.password)
        state.isLoading = false
        switch result {
        case .success:
            log.info("🔐 Sign in succeeded")
            state.didSucceed = true
        case .failure(let err):
            log.error("🔐 Sign in failed: \(String(describing: err))")
            state.error = Self.errorMessage(err)
        }
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .server(_, _, let msg): return msg
        case .unauthorized: return "Invalid credentials."
        case .network: return "Network error."
        case .offline: return "You're offline."
        case .decoding, .invalidResponse: return "Unexpected response."
        case .notAMedicalDocument: return "Unexpected response."
        }
    }
}
