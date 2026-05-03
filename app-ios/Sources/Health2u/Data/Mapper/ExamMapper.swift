import Foundation

extension ExamDTO {
    public func toDomain() -> Exam {
        Exam(
            id: id,
            userId: userId,
            title: title,
            type: type,
            date: date,
            fileUrl: fileUrl,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension Exam {
    public func toDTO() -> ExamDTO {
        ExamDTO(
            id: id,
            userId: userId,
            title: title,
            type: type,
            date: date,
            fileUrl: fileUrl,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public func toEntity() -> ExamEntity {
        ExamEntity(
            id: id,
            userId: userId,
            title: title,
            type: type,
            date: date,
            fileUrl: fileUrl,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

extension ExamEntity {
    public func toDomain() -> Exam {
        Exam(
            id: id,
            userId: userId,
            title: title,
            type: type,
            date: date,
            fileUrl: fileUrl,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
