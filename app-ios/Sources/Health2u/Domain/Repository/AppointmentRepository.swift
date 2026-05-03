import Foundation

public protocol AppointmentRepository: Sendable {
    func getAppointments() async -> Result<[Appointment], APIError>
    func getAppointment(id: String) async -> Result<Appointment, APIError>
    func createAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError>
    func updateAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError>
    func deleteAppointment(id: String) async -> Result<Void, APIError>
    func observeAppointments() -> AsyncStream<[Appointment]>
}
