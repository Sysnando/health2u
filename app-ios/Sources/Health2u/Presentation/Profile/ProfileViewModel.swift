import Foundation

@MainActor
public final class ProfileViewModel: ObservableObject {
    @Published public var state = ProfileState()

    private let userRepository: any UserRepository

    public init(userRepository: any UserRepository) {
        self.userRepository = userRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await userRepository.getProfile()

        switch result {
        case .success(let user):
            state.user = user
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Failed to load profile."
        }
    }
}
