import Foundation

public struct ExamsState: Equatable {
    public var exams: [Exam] = []
    public var filter: String? = nil
    public var isLoading: Bool = false
    public var error: String? = nil

    public init() {}
}
