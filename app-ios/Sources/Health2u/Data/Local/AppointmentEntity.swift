import Foundation

public struct AppointmentEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var userId: String
    public var title: String
    public var descriptionText: String?
    public var doctorName: String?
    public var location: String?
    public var dateTime: Date
    public var reminderMinutes: Int?
    public var status: String
    public var createdAt: Date

    public init(
        id: String,
        userId: String,
        title: String,
        descriptionText: String? = nil,
        doctorName: String? = nil,
        location: String? = nil,
        dateTime: Date,
        reminderMinutes: Int? = nil,
        status: String,
        createdAt: Date
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.descriptionText = descriptionText
        self.doctorName = doctorName
        self.location = location
        self.dateTime = dateTime
        self.reminderMinutes = reminderMinutes
        self.status = status
        self.createdAt = createdAt
    }
}
