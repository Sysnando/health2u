import Foundation

public protocol AuthRepository: Sendable {
    func login(email: String, password: String) async -> Result<Void, APIError>
    func refreshIfNeeded() async -> Result<Void, APIError>
    func logout() async -> Result<Void, APIError>
    func isAuthenticated() async -> Bool
}
