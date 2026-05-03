public struct LoginState: Equatable, Sendable {
    public var email = ""
    public var password = ""
    public var isLoading = false
    public var error: String? = nil
    public var didSucceed = false
    public init() {}
}
