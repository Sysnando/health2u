import Foundation

extension UserDTO {
    public func toDomain() -> User {
        User(
            id: id,
            email: email,
            name: name,
            profilePictureUrl: profilePictureUrl,
            dateOfBirth: dateOfBirth,
            phone: phone,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            bloodType: bloodType,
            hasDiabetes: hasDiabetes,
            hasAllergies: hasAllergies
        )
    }
}

extension User {
    public func toDTO() -> UserDTO {
        UserDTO(
            id: id,
            email: email,
            name: name,
            profilePictureUrl: profilePictureUrl,
            dateOfBirth: dateOfBirth,
            phone: phone,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            bloodType: bloodType,
            hasDiabetes: hasDiabetes,
            hasAllergies: hasAllergies
        )
    }

    public func toEntity() -> UserEntity {
        UserEntity(
            id: id,
            email: email,
            name: name,
            profilePictureUrl: profilePictureUrl,
            dateOfBirth: dateOfBirth,
            phone: phone,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            bloodType: bloodType,
            hasDiabetes: hasDiabetes,
            hasAllergies: hasAllergies
        )
    }
}

extension UserEntity {
    public func toDomain() -> User {
        User(
            id: id,
            email: email,
            name: name,
            profilePictureUrl: profilePictureUrl,
            dateOfBirth: dateOfBirth,
            phone: phone,
            gender: gender,
            heightCm: heightCm,
            weightKg: weightKg,
            bloodType: bloodType,
            hasDiabetes: hasDiabetes,
            hasAllergies: hasAllergies
        )
    }
}
