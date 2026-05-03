import Foundation

public enum AppointmentStatus: String, Codable, Sendable, Equatable {
    case upcoming = "UPCOMING"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

public struct Appointment: Identifiable, Equatable, Sendable {
    public let id: String
    public let userId: String
    public let title: String
    public let description: String?
    public let doctorName: String?
    public let location: String?
    public let dateTime: Date
    public let reminderMinutes: Int?
    public let status: AppointmentStatus
    public let createdAt: Date

    public init(
        id: String,
        userId: String,
        title: String,
        description: String? = nil,
        doctorName: String? = nil,
        location: String? = nil,
        dateTime: Date,
        reminderMinutes: Int? = nil,
        status: AppointmentStatus,
        createdAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.description = description
        self.doctorName = doctorName
        self.location = location
        self.dateTime = dateTime
        self.reminderMinutes = reminderMinutes
        self.status = status
        self.createdAt = createdAt
    }
}
