import Foundation

@MainActor
public final class NotificationsViewModel: ObservableObject {
    @Published public var state = NotificationsState()

    public init() {}

    public func load() async {
        state.isLoading = true
        try? await Task.sleep(nanoseconds: 500_000_000)
        state.notifications = Self.mockNotifications()
        state.isLoading = false
    }

    private static func mockNotifications() -> [NotificationsState.Notification] {
        let now = Date()
        return [
            .init(
                id: "1",
                icon: "calendar.badge.clock",
                title: "Upcoming Appointment",
                message: "You have a cardiology check-up scheduled for tomorrow at 10:00 AM.",
                timestamp: now.addingTimeInterval(-3600),
                isRead: false
            ),
            .init(
                id: "2",
                icon: "doc.text.fill",
                title: "Lab Results Ready",
                message: "Your Complete Blood Count results are now available. Tap to view.",
                timestamp: now.addingTimeInterval(-7200),
                isRead: false
            ),
            .init(
                id: "3",
                icon: "pills.fill",
                title: "Medication Reminder",
                message: "Time to take your daily Vitamin D supplement.",
                timestamp: now.addingTimeInterval(-14400),
                isRead: true
            ),
            .init(
                id: "4",
                icon: "heart.text.square.fill",
                title: "Health Score Updated",
                message: "Your health score improved by 4 points this month. Keep it up!",
                timestamp: now.addingTimeInterval(-86400),
                isRead: true
            ),
            .init(
                id: "5",
                icon: "person.2.fill",
                title: "Emergency Contact Added",
                message: "Maria Santos was added as your emergency contact.",
                timestamp: now.addingTimeInterval(-172800),
                isRead: true
            ),
            .init(
                id: "6",
                icon: "shield.checkered",
                title: "Insurance Renewal",
                message: "Your health insurance policy is up for renewal in 15 days.",
                timestamp: now.addingTimeInterval(-259200),
                isRead: true
            ),
        ]
    }
}
