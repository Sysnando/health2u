import Foundation

public struct RegistrationState: Equatable, Sendable {
    public var name: String = ""
    public var email: String = ""
    public var password: String = ""
    public var confirmPassword: String = ""
    public var agreedToTerms: Bool = false
    public var isLoading: Bool = false
    public var error: String? = nil
    public var didSucceed: Bool = false

    public init() {}
}
