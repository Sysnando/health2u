import Foundation

public actor SessionStore {
    private let tokenStore: KeychainTokenStore
    private var _accessToken: String?
    private var _refreshToken: String?
    private var _userId: String?

    public init(tokenStore: KeychainTokenStore = .init()) {
        self.tokenStore = tokenStore
    }

    public func loadFromKeychain() async {
        _accessToken = tokenStore.load(key: "accessToken")
        _refreshToken = tokenStore.load(key: "refreshToken")
        _userId = tokenStore.load(key: "userId")
    }

    public func currentUserId() async -> String? { _userId }
    public func accessToken() async -> String? { _accessToken }
    public func refreshToken() async -> String? { _refreshToken }
    public func isAuthenticated() async -> Bool { _accessToken != nil }

    public func setSession(userId: String, accessToken: String, refreshToken: String) async throws {
        try tokenStore.save(key: "accessToken", value: accessToken)
        try tokenStore.save(key: "refreshToken", value: refreshToken)
        try tokenStore.save(key: "userId", value: userId)
        _accessToken = accessToken; _refreshToken = refreshToken; _userId = userId
    }

    public func clear() async throws {
        try tokenStore.deleteAll()
        _accessToken = nil; _refreshToken = nil; _userId = nil
    }
}
