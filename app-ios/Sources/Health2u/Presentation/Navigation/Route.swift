import Foundation

public enum Route: Hashable, Sendable {
    case welcome
    case login
    case dashboard
    case exams
    case examDetail(id: String)
    case insights
    case upload
    case appointments
    case appointmentDetail(id: String)
    case profile
    case editProfile
    case emergencyContacts
    case settings
    case registration
    case notifications
}
