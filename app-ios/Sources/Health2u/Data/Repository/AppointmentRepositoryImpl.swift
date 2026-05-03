import Foundation

public final class AppointmentRepositoryImpl: AppointmentRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getAppointments() async -> Result<[Appointment], APIError> {
        switch await apiClient.getAppointments() {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(appointments: domains.map { $0.toEntity() })
            return .success(domains)
        case .failure(let error):
            let cached = await database.allAppointments().map { $0.toDomain() }
            if !cached.isEmpty { return .success(cached) }
            return .failure(error)
        }
    }

    public func getAppointment(id: String) async -> Result<Appointment, APIError> {
        if let cached = await database.getAppointment(id: id) {
            return .success(cached.toDomain())
        }
        return .failure(.invalidResponse)
    }

    public func createAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError> {
        switch await apiClient.createAppointment(appointment.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(appointment: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func updateAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError> {
        switch await apiClient.updateAppointment(id: appointment.id, appointment.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(appointment: domain.toEntity())
            return .success(domain)
        case .failure(let error):
            return .failure(error)
        }
    }

    public func deleteAppointment(id: String) async -> Result<Void, APIError> {
        switch await apiClient.deleteAppointment(id: id) {
        case .success:
            await database.deleteAppointment(id: id)
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    public func observeAppointments() -> AsyncStream<[Appointment]> {
        AsyncStream { continuation in
            Task {
                let current = await self.database.allAppointments().map { $0.toDomain() }
                continuation.yield(current)
                continuation.finish()
            }
        }
    }
}
