import Foundation

public struct AppointmentsState: Equatable {
    public var appointments: [Appointment] = []
    public var isLoading: Bool = false
    public var error: String? = nil

    public init() {}
}
