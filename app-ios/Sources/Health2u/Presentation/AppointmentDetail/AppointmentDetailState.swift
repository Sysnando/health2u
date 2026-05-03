import Foundation

public struct AppointmentDetailState: Equatable {
    public var appointment: Appointment? = nil
    public var isLoading: Bool = false
    public var isDeleting: Bool = false
    public var error: String? = nil
    public var didDelete: Bool = false

    public init() {}
}
