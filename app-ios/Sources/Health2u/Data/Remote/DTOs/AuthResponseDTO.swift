import Foundation

public struct AuthResponseDTO: Codable, Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let user: UserDTO

    public init(accessToken: String, refreshToken: String, user: UserDTO) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.user = user
    }
}

public struct LoginRequestDTO: Codable, Equatable, Sendable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct RefreshTokenRequestDTO: Codable, Equatable, Sendable {
    public let refreshToken: String

    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
}
