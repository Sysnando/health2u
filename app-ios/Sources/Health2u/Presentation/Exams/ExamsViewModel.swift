import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "ExamsVM")

@MainActor
public final class ExamsViewModel: ObservableObject {
    @Published public var state = ExamsState()

    private let examRepository: any ExamRepository

    public init(examRepository: any ExamRepository) {
        self.examRepository = examRepository
    }

    public func load() async {
        log.info("📋 ExamsVM loading (filter: \(self.state.filter ?? "none"))")
        state.isLoading = true
        state.error = nil

        let result = await examRepository.getExams(filter: state.filter)

        switch result {
        case .success(let exams):
            state.exams = exams
            log.info("📋 ExamsVM loaded \(exams.count) exams")
        case .failure(let err):
            log.error("📋 ExamsVM load failed: \(String(describing: err))")
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    public func setFilter(_ filter: String?) async {
        log.info("📋 ExamsVM filter changed to: \(filter ?? "none")")
        state.filter = filter
        await load()
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Failed to load exams."
        }
    }
}
