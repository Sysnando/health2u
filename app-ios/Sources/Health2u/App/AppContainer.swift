import Foundation
import SwiftUI

@MainActor
public final class AppContainer: ObservableObject {
    public let apiClient: APIClient
    public let database: HealthDatabase
    public let sessionStore: SessionStore
    public let userRepository: any UserRepository
    public let examRepository: any ExamRepository
    public let appointmentRepository: any AppointmentRepository
    public let emergencyContactRepository: any EmergencyContactRepository
    public let healthInsightRepository: any HealthInsightRepository
    public let authRepository: any AuthRepository

    @Published public var isAuthenticated: Bool = false
    @Published public var isReady: Bool = false
    @Published public var path: [Route] = []

    public init() {
        #if DEBUG
        let baseURL = URL(string: "https://dwpsoujnnwyqzqxvqtib.supabase.co/functions/v1/admin")!
        #else
        let baseURL = URL(string: "https://dwpsoujnnwyqzqxvqtib.supabase.co/functions/v1/admin")!
        #endif
        let sessionStore = SessionStore()
        self.sessionStore = sessionStore
        self.apiClient = APIClient(baseURL: baseURL, tokenProvider: { await sessionStore.accessToken() })
        self.database = HealthDatabase()
        self.userRepository = UserRepositoryImpl(apiClient: apiClient, database: database)
        self.examRepository = ExamRepositoryImpl(apiClient: apiClient, database: database)
        self.appointmentRepository = AppointmentRepositoryImpl(apiClient: apiClient, database: database)
        self.emergencyContactRepository = EmergencyContactRepositoryImpl(apiClient: apiClient, database: database)
        self.healthInsightRepository = HealthInsightRepositoryImpl(apiClient: apiClient, database: database)
        self.authRepository = AuthRepositoryImpl(apiClient: apiClient, sessionStore: sessionStore)

        Task {
            await sessionStore.loadFromKeychain()
            let auth = await sessionStore.isAuthenticated()
            await MainActor.run {
                self.isAuthenticated = auth
                self.isReady = true
            }
        }
    }

    public func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authRepository: authRepository)
    }

    public func makeDashboardViewModel() -> DashboardViewModel {
        DashboardViewModel(
            userRepository: userRepository,
            examRepository: examRepository,
            appointmentRepository: appointmentRepository,
            healthInsightRepository: healthInsightRepository
        )
    }

    public func makeExamsViewModel() -> ExamsViewModel {
        ExamsViewModel(examRepository: examRepository)
    }

    public func makeExamDetailViewModel(id: String) -> ExamDetailViewModel {
        ExamDetailViewModel(id: id, examRepository: examRepository)
    }

    public func makeInsightsViewModel() -> InsightsViewModel {
        InsightsViewModel(healthInsightRepository: healthInsightRepository)
    }

    public func makeUploadViewModel() -> UploadViewModel {
        UploadViewModel(examRepository: examRepository)
    }

    public func makeAppointmentsViewModel() -> AppointmentsViewModel {
        AppointmentsViewModel(appointmentRepository: appointmentRepository)
    }

    public func makeAppointmentDetailViewModel(id: String) -> AppointmentDetailViewModel {
        AppointmentDetailViewModel(id: id, appointmentRepository: appointmentRepository)
    }

    public func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(userRepository: userRepository)
    }

    public func makeEditProfileViewModel() -> EditProfileViewModel {
        EditProfileViewModel(userRepository: userRepository)
    }

    public func makeEmergencyContactsViewModel() -> EmergencyContactsViewModel {
        EmergencyContactsViewModel(emergencyContactRepository: emergencyContactRepository)
    }

    public func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(authRepository: authRepository)
    }

    public func makeRegistrationViewModel() -> RegistrationViewModel {
        RegistrationViewModel()
    }

    public func makeNotificationsViewModel() -> NotificationsViewModel {
        NotificationsViewModel()
    }
}
