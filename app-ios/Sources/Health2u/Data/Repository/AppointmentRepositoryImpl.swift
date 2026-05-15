import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "AppointmentRepo")

public final class AppointmentRepositoryImpl: AppointmentRepository, @unchecked Sendable {
    private let apiClient: APIClient
    private let database: HealthDatabase

    public init(apiClient: APIClient, database: HealthDatabase) {
        self.apiClient = apiClient
        self.database = database
    }

    public func getAppointments() async -> Result<[Appointment], APIError> {
        log.info("📅 getAppointments")
        switch await apiClient.getAppointments() {
        case .success(let dtos):
            let domains = dtos.map { $0.toDomain() }
            await database.upsert(appointments: domains.map { $0.toEntity() })
            log.info("📅 getAppointments → \(domains.count) from API")
            return .success(domains)
        case .failure(let error):
            let cached = await database.allAppointments().map { $0.toDomain() }
            if !cached.isEmpty {
                log.warning("📅 getAppointments → API failed, returning \(cached.count) cached")
                return .success(cached)
            }
            log.error("📅 getAppointments → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func getAppointment(id: String) async -> Result<Appointment, APIError> {
        log.info("📅 getAppointment(id: \(id))")
        if let cached = await database.getAppointment(id: id) {
            log.info("📅 getAppointment → found in cache")
            return .success(cached.toDomain())
        }
        log.error("📅 getAppointment → not found")
        return .failure(.invalidResponse)
    }

    public func createAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError> {
        log.info("📅 createAppointment: \(appointment.title)")
        switch await apiClient.createAppointment(appointment.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(appointment: domain.toEntity())
            log.info("📅 createAppointment → success, id: \(domain.id)")
            return .success(domain)
        case .failure(let error):
            log.error("📅 createAppointment → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func updateAppointment(_ appointment: Appointment) async -> Result<Appointment, APIError> {
        log.info("📅 updateAppointment(id: \(appointment.id))")
        switch await apiClient.updateAppointment(id: appointment.id, appointment.toDTO()) {
        case .success(let dto):
            let domain = dto.toDomain()
            await database.upsert(appointment: domain.toEntity())
            log.info("📅 updateAppointment → success")
            return .success(domain)
        case .failure(let error):
            log.error("📅 updateAppointment → failed: \(String(describing: error))")
            return .failure(error)
        }
    }

    public func deleteAppointment(id: String) async -> Result<Void, APIError> {
        log.info("🗑️ deleteAppointment(id: \(id))")
        switch await apiClient.deleteAppointment(id: id) {
        case .success:
            await database.deleteAppointment(id: id)
            log.info("🗑️ deleteAppointment → success")
            return .success(())
        case .failure(let error):
            log.error("🗑️ deleteAppointment → failed: \(String(describing: error))")
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
