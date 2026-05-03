import Foundation

public struct DashboardState: Equatable {
    public var userName: String = ""
    public var healthScore: Int = 0
    public var recentExams: [Exam] = []
    public var upcomingAppointments: [Appointment] = []
    public var insights: [HealthInsight] = []
    public var isLoading: Bool = false
    public var error: String? = nil

    public init() {}
}
