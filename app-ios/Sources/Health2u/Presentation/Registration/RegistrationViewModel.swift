import Foundation

@MainActor
public final class RegistrationViewModel: ObservableObject {
    @Published public var state = RegistrationState()

    public init() {}

    public func register() async {
        guard !state.name.isEmpty else { state.error = "Name is required."; return }
        guard !state.email.isEmpty else { state.error = "Email is required."; return }
        guard !state.password.isEmpty else { state.error = "Password is required."; return }
        guard state.password == state.confirmPassword else { state.error = "Passwords don't match."; return }
        guard state.agreedToTerms else { state.error = "Please agree to the terms."; return }

        state.isLoading = true
        state.error = nil

        // Simulate network call — will be replaced with real API in the future
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        state.isLoading = false
        state.didSucceed = true
    }
}
