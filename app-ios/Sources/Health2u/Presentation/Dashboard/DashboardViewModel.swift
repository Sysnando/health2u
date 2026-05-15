import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "DashboardVM")

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public var state = DashboardState()

    private let userRepository: any UserRepository
    private let examRepository: any ExamRepository
    private let appointmentRepository: any AppointmentRepository
    private let healthInsightRepository: any HealthInsightRepository
    private let onSessionExpired: (() -> Void)?

    public init(
        userRepository: any UserRepository,
        examRepository: any ExamRepository,
        appointmentRepository: any AppointmentRepository,
        healthInsightRepository: any HealthInsightRepository,
        onSessionExpired: (() -> Void)? = nil
    ) {
        self.userRepository = userRepository
        self.examRepository = examRepository
        self.appointmentRepository = appointmentRepository
        self.healthInsightRepository = healthInsightRepository
        self.onSessionExpired = onSessionExpired
    }

    public func load() async {
        log.info("🏠 Dashboard loading")
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
            log.info("🏠 Profile loaded: \(user.name)")
        } else if case .failure(let err) = profile {
            log.error("🏠 Profile failed: \(String(describing: err))")
        }

        if case .success(let examList) = exams {
            state.recentExams = Array(examList.prefix(3))
            log.info("🏠 Exams loaded: \(examList.count) total, showing \(self.state.recentExams.count)")
        } else if case .failure(let err) = exams {
            log.error("🏠 Exams failed: \(String(describing: err))")
        }

        if case .success(let appointmentList) = appointments {
            state.upcomingAppointments = appointmentList.filter { $0.status == .upcoming }
            log.info("🏠 Appointments loaded: \(appointmentList.count) total, \(self.state.upcomingAppointments.count) upcoming")
        } else if case .failure(let err) = appointments {
            log.error("🏠 Appointments failed: \(String(describing: err))")
        }

        if case .success(let insightList) = insights {
            state.insights = insightList
            state.healthScore = insightList.isEmpty ? 0 : 85
            log.info("🏠 Insights loaded: \(insightList.count)")
        } else if case .failure(let err) = insights {
            log.error("🏠 Insights failed: \(String(describing: err))")
        }

        if case .failure(let err) = profile,
           case .failure = exams,
           case .failure = appointments {
            if case .unauthorized = err {
                log.error("🏠 All requests unauthorized — session expired")
                onSessionExpired?()
                return
            }
            state.error = Self.errorMessage(err)
        }

        log.info("🏠 Dashboard load complete")
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
