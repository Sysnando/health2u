import Foundation

public struct ProfileState: Equatable {
    public var user: User? = nil
    public var isLoading: Bool = false
    public var error: String? = nil

    public init() {}
}
