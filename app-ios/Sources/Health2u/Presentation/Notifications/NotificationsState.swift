import Foundation

public struct NotificationsState: Equatable {
    public struct Notification: Equatable, Identifiable {
        public let id: String
        public let icon: String
        public let title: String
        public let message: String
        public let timestamp: Date
        public let isRead: Bool
    }

    public var notifications: [Notification] = []
    public var isLoading: Bool = false

    public init() {}
}
