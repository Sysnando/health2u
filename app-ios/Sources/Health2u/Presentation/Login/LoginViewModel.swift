import Foundation

@MainActor
public final class LoginViewModel: ObservableObject {
    @Published public var state = LoginState()
    private let authRepository: AuthRepository

    public init(authRepository: AuthRepository) { self.authRepository = authRepository }

    public func signIn() async {
        guard !state.email.isEmpty, !state.password.isEmpty else {
            state.error = "Email and password are required."; return
        }
        state.isLoading = true; state.error = nil
        let result = await authRepository.login(email: state.email, password: state.password)
        state.isLoading = false
        switch result {
        case .success: state.didSucceed = true
        case .failure(let err):
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
        }
    }
}
