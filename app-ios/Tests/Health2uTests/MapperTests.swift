import XCTest
@testable import Health2u

final class MapperTests: XCTestCase {

    // MARK: - Exam

    func testExamDTORoundTrip() {
        let dto = ExamDTO(
            id: "1",
            userId: "u",
            title: "T",
            type: "Labs",
            date: Date(timeIntervalSince1970: 0),
            fileUrl: nil,
            notes: nil,
            createdAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 0)
        )
        let domain = dto.toDomain()
        let entity = domain.toEntity()
        let back = entity.toDomain()
        XCTAssertEqual(domain, back)
    }

    func testExamDomainToDTORoundTrip() {
        let exam = Exam(
            id: "e1",
            userId: "u1",
            title: "Blood Test",
            type: "Labs",
            date: Date(timeIntervalSince1970: 1000),
            fileUrl: "http://example.com/file.pdf",
            notes: "Some notes",
            createdAt: Date(timeIntervalSince1970: 500),
            updatedAt: Date(timeIntervalSince1970: 900)
        )
        let dto = exam.toDTO()
        let back = dto.toDomain()
        XCTAssertEqual(exam, back)
    }

    // MARK: - User

    func testUserDTORoundTrip() {
        let dto = UserDTO(
            id: "u1",
            email: "test@example.com",
            name: "Test User",
            profilePictureUrl: nil,
            dateOfBirth: Date(timeIntervalSince1970: 0),
            phone: "+1234567890"
        )
        let domain = dto.toDomain()
        let entity = domain.toEntity()
        let back = entity.toDomain()
        XCTAssertEqual(domain, back)
    }

    // MARK: - Appointment

    func testAppointmentDTORoundTrip() {
        let dto = AppointmentDTO(
            id: "a1",
            userId: "u1",
            title: "Checkup",
            description: "Annual checkup",
            doctorName: "Dr. Smith",
            location: "Clinic",
            dateTime: Date(timeIntervalSince1970: 2000),
            reminderMinutes: 30,
            status: "UPCOMING",
            createdAt: Date(timeIntervalSince1970: 1000)
        )
        let domain = dto.toDomain()
        let entity = domain.toEntity()
        let back = entity.toDomain()
        XCTAssertEqual(domain, back)
        XCTAssertEqual(domain.status, .upcoming)
    }

    // MARK: - EmergencyContact

    func testEmergencyContactDTORoundTrip() {
        let dto = EmergencyContactDTO(
            id: "c1",
            userId: "u1",
            name: "Jane",
            relationship: "Sister",
            phone: "+1234567890",
            email: "jane@example.com",
            isPrimary: true,
            order: 0
        )
        let domain = dto.toDomain()
        let entity = domain.toEntity()
        let back = entity.toDomain()
        XCTAssertEqual(domain, back)
    }

    // MARK: - HealthInsight

    func testHealthInsightDTORoundTrip() {
        let dto = HealthInsightDTO(
            id: "i1",
            userId: "u1",
            type: "heart_rate",
            title: "Heart Rate",
            description: "Normal range",
            metricValue: 72.0,
            timestamp: Date(timeIntervalSince1970: 3000),
            createdAt: Date(timeIntervalSince1970: 2000)
        )
        let domain = dto.toDomain()
        let entity = domain.toEntity()
        let back = entity.toDomain()
        XCTAssertEqual(domain, back)
    }
}
