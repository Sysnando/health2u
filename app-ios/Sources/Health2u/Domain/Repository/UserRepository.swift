import Foundation

public protocol UserRepository: Sendable {
    func getProfile() async -> Result<User, APIError>
    func updateProfile(_ user: User) async -> Result<User, APIError>
    func observeProfile() -> AsyncStream<User?>
    func uploadProfilePhoto(imageData: Data, filename: String) async -> Result<User, APIError>
    func logout() async -> Result<Void, APIError>
}
