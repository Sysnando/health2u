import Foundation

public actor HealthDatabase {
    public static let shared = HealthDatabase()
    public init() {}

    private var users: [String: UserEntity] = [:]
    private var exams: [String: ExamEntity] = [:]
    private var appointments: [String: AppointmentEntity] = [:]
    private var emergencyContacts: [String: EmergencyContactEntity] = [:]
    private var healthInsights: [String: HealthInsightEntity] = [:]

    // Users
    public func getUser(id: String) -> UserEntity? { users[id] }
    public func allUsers() -> [UserEntity] { Array(users.values) }
    public func upsert(user: UserEntity) { users[user.id] = user }
    public func deleteUser(id: String) { users.removeValue(forKey: id) }

    // Exams
    public func getExam(id: String) -> ExamEntity? { exams[id] }
    public func allExams() -> [ExamEntity] { Array(exams.values).sorted { $0.date > $1.date } }
    public func upsert(exams new: [ExamEntity]) { for e in new { exams[e.id] = e } }
    public func upsert(exam: ExamEntity) { exams[exam.id] = exam }
    public func deleteExam(id: String) { exams.removeValue(forKey: id) }

    // Appointments
    public func getAppointment(id: String) -> AppointmentEntity? { appointments[id] }
    public func allAppointments() -> [AppointmentEntity] { Array(appointments.values).sorted { $0.dateTime < $1.dateTime } }
    public func upsert(appointments new: [AppointmentEntity]) { for a in new { appointments[a.id] = a } }
    public func upsert(appointment: AppointmentEntity) { appointments[appointment.id] = appointment }
    public func deleteAppointment(id: String) { appointments.removeValue(forKey: id) }

    // Emergency contacts
    public func getContact(id: String) -> EmergencyContactEntity? { emergencyContacts[id] }
    public func allContacts() -> [EmergencyContactEntity] { Array(emergencyContacts.values).sorted { $0.order < $1.order } }
    public func upsert(contacts new: [EmergencyContactEntity]) { for c in new { emergencyContacts[c.id] = c } }
    public func upsert(contact: EmergencyContactEntity) { emergencyContacts[contact.id] = contact }
    public func deleteContact(id: String) { emergencyContacts.removeValue(forKey: id) }

    // Insights
    public func getInsight(id: String) -> HealthInsightEntity? { healthInsights[id] }
    public func allInsights() -> [HealthInsightEntity] { Array(healthInsights.values).sorted { $0.timestamp > $1.timestamp } }
    public func upsert(insights new: [HealthInsightEntity]) { for i in new { healthInsights[i.id] = i } }

    // Reset
    public func clear() {
        users.removeAll(); exams.removeAll(); appointments.removeAll()
        emergencyContacts.removeAll(); healthInsights.removeAll()
    }
}

public enum HealthDatabaseFactory {
    public static func makeContainer() -> HealthDatabase { HealthDatabase() }
}
