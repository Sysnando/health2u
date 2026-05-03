import Foundation

extension EmergencyContactDTO {
    public func toDomain() -> EmergencyContact {
        EmergencyContact(
            id: id,
            userId: userId,
            name: name,
            relationship: relationship,
            phone: phone,
            email: email,
            isPrimary: isPrimary,
            order: order
        )
    }
}

extension EmergencyContact {
    public func toDTO() -> EmergencyContactDTO {
        EmergencyContactDTO(
            id: id,
            userId: userId,
            name: name,
            relationship: relationship,
            phone: phone,
            email: email,
            isPrimary: isPrimary,
            order: order
        )
    }

    public func toEntity() -> EmergencyContactEntity {
        EmergencyContactEntity(
            id: id,
            userId: userId,
            name: name,
            relationship: relationship,
            phone: phone,
            email: email,
            isPrimary: isPrimary,
            order: order
        )
    }
}

extension EmergencyContactEntity {
    public func toDomain() -> EmergencyContact {
        EmergencyContact(
            id: id,
            userId: userId,
            name: name,
            relationship: relationship,
            phone: phone,
            email: email,
            isPrimary: isPrimary,
            order: order
        )
    }
}
