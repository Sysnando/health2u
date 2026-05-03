import Foundation

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public var state = DashboardState()

    private let userRepository: any UserRepository
    private let examRepository: any ExamRepository
    private let appointmentRepository: any AppointmentRepository
    private let healthInsightRepository: any HealthInsightRepository

    public init(
        userRepository: any UserRepository,
        examRepository: any ExamRepository,
        appointmentRepository: any AppointmentRepository,
        healthInsightRepository: any HealthInsightRepository
    ) {
        self.userRepository = userRepository
        self.examRepository = examRepository
        self.appointmentRepository = appointmentRepository
        self.healthInsightRepository = healthInsightRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        async let profileResult = userRepository.getProfile()
        async let examsResult = examRepository.getExams(filter: nil)
        async let appointmentsResult = appointmentRepository.getAppointments()
        async let insightsResult = healthInsightRepository.getHealthInsights()

        let (profile, exams, appointments, insights) = await (
            profileResult, examsResult, appointmentsResult, insightsResult
        )

        if case .success(let user) = profile {
            state.userName = user.name
        }

        if case .success(let examList) = exams {
            state.recentExams = Array(examList.prefix(3))
        }

        if case .success(let appointmentList) = appointments {
            state.upcomingAppointments = appointmentList.filter { $0.status == .upcoming }
        }

        if case .success(let insightList) = insights {
            state.insights = insightList
            state.healthScore = insightList.isEmpty ? 0 : 85
        }

        if case .failure(let err) = profile,
           case .failure = exams,
           case .failure = appointments {
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .unauthorized: return "Session expired. Please sign in again."
        case .server(_, _, let msg): return msg
        default: return "Failed to load dashboard."
        }
    }
}
