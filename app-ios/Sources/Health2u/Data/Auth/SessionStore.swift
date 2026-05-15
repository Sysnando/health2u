import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "SessionStore")

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
        let hasTokens = _accessToken != nil
        log.info("🔑 Keychain loaded — authenticated: \(hasTokens), userId: \(self._userId ?? "nil")")
    }

    public func currentUserId() async -> String? { _userId }
    public func accessToken() async -> String? { _accessToken }
    public func refreshToken() async -> String? { _refreshToken }
    public func isAuthenticated() async -> Bool { _accessToken != nil }

    public func setSession(userId: String, accessToken: String, refreshToken: String) async throws {
        log.info("🔑 Saving session for userId: \(userId)")
        try tokenStore.save(key: "accessToken", value: accessToken)
        try tokenStore.save(key: "refreshToken", value: refreshToken)
        try tokenStore.save(key: "userId", value: userId)
        _accessToken = accessToken; _refreshToken = refreshToken; _userId = userId
        log.info("🔑 Session saved to keychain")
    }

    public func clear() async throws {
        log.info("🔑 Clearing session and keychain")
        try tokenStore.deleteAll()
        _accessToken = nil; _refreshToken = nil; _userId = nil
    }
}
