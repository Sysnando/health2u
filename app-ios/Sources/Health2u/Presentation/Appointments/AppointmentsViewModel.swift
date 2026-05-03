import Foundation

@MainActor
public final class AppointmentsViewModel: ObservableObject {
    @Published public var state = AppointmentsState()

    private let appointmentRepository: any AppointmentRepository

    public init(appointmentRepository: any AppointmentRepository) {
        self.appointmentRepository = appointmentRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await appointmentRepository.getAppointments()

        switch result {
        case .success(let appointments):
            state.appointments = appointments
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Failed to load appointments."
        }
    }
}
