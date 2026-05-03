import Foundation

@MainActor
public final class ExamDetailViewModel: ObservableObject {
    @Published public var state = ExamDetailState()

    private let id: String
    private let examRepository: any ExamRepository

    public init(id: String, examRepository: any ExamRepository) {
        self.id = id
        self.examRepository = examRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await examRepository.getExam(id: id)

        switch result {
        case .success(let exam):
            state.exam = exam
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    public func deleteExam() async {
        state.isDeleting = true
        let result = await examRepository.deleteExam(id: id)

        switch result {
        case .success:
            state.didDelete = true
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isDeleting = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "An error occurred."
        }
    }
}
