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
            updatedAt: updatedAt,
            analysis: analysis?.toDomain()
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
            updatedAt: updatedAt,
            analysis: analysis?.toDTO()
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
            updatedAt: updatedAt,
            analysis: analysis?.toEntity()
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
            updatedAt: updatedAt,
            analysis: analysis?.toDomain()
        )
    }
}
