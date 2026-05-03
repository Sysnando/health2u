import Foundation

extension AppointmentDTO {
    public func toDomain() -> Appointment {
        Appointment(
            id: id,
            userId: userId,
            title: title,
            description: description,
            doctorName: doctorName,
            location: location,
            dateTime: dateTime,
            reminderMinutes: reminderMinutes,
            status: AppointmentStatus(rawValue: status) ?? .upcoming,
            createdAt: createdAt
        )
    }
}

extension Appointment {
    public func toDTO() -> AppointmentDTO {
        AppointmentDTO(
            id: id,
            userId: userId,
            title: title,
            description: description,
            doctorName: doctorName,
            location: location,
            dateTime: dateTime,
            reminderMinutes: reminderMinutes,
            status: status.rawValue,
            createdAt: createdAt
        )
    }

    public func toEntity() -> AppointmentEntity {
        AppointmentEntity(
            id: id,
            userId: userId,
            title: title,
            descriptionText: description,
            doctorName: doctorName,
            location: location,
            dateTime: dateTime,
            reminderMinutes: reminderMinutes,
            status: status.rawValue,
            createdAt: createdAt
        )
    }
}

extension AppointmentEntity {
    public func toDomain() -> Appointment {
        Appointment(
            id: id,
            userId: userId,
            title: title,
            description: descriptionText,
            doctorName: doctorName,
            location: location,
            dateTime: dateTime,
            reminderMinutes: reminderMinutes,
            status: AppointmentStatus(rawValue: status) ?? .upcoming,
            createdAt: createdAt
        )
    }
}
