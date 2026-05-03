import Foundation

@MainActor
public final class WelcomeViewModel: ObservableObject {
    @Published public var state = WelcomeState()
    public init() {}
}
