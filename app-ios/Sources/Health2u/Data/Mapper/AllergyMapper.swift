import Foundation

extension AllergyDTO {
    public func toDomain() -> Allergy {
        Allergy(id: id, userId: userId, name: name, severity: severity, notes: notes, createdAt: createdAt)
    }
}

extension Allergy {
    public func toDTO() -> AllergyDTO {
        AllergyDTO(id: id, userId: userId, name: name, severity: severity, notes: notes, createdAt: createdAt)
    }
    public func toEntity() -> AllergyEntity {
        AllergyEntity(id: id, userId: userId, name: name, severity: severity, notes: notes, createdAt: createdAt)
    }
}

extension AllergyEntity {
    public func toDomain() -> Allergy {
        Allergy(id: id, userId: userId, name: name, severity: severity, notes: notes, createdAt: createdAt)
    }
}
