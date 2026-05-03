import Foundation

public struct ExamDetailState: Equatable {
    public var exam: Exam? = nil
    public var isLoading: Bool = false
    public var isDeleting: Bool = false
    public var error: String? = nil
    public var didDelete: Bool = false

    public init() {}
}
