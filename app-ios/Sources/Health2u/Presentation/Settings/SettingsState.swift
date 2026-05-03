import Foundation

public struct SettingsState: Equatable {
    public var notificationsEnabled: Bool = true
    public var isLoggingOut: Bool = false
    public var error: String? = nil

    public init() {}
}
