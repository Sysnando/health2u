import Foundation

@MainActor
public final class AppointmentDetailViewModel: ObservableObject {
    @Published public var state = AppointmentDetailState()

    private let id: String
    private let appointmentRepository: any AppointmentRepository

    public init(id: String, appointmentRepository: any AppointmentRepository) {
        self.id = id
        self.appointmentRepository = appointmentRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await appointmentRepository.getAppointment(id: id)

        switch result {
        case .success(let appointment):
            state.appointment = appointment
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    public func deleteAppointment() async {
        state.isDeleting = true
        let result = await appointmentRepository.deleteAppointment(id: id)

        switch result {
        case .success:
            state.didDelete = true
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isDeleting = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "An error occurred."
        }
    }
}
