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
        log.info("📋 [VM] load() start (filter: \(self.state.filter ?? "none"))")
        state.isLoading = true
        state.error = nil

        let result = await examRepository.getExams(filter: state.filter)

        switch result {
        case .success(let exams):
            state.exams = exams
            var counts: [String: Int] = [:]
            var unmapped: [String] = []
            for exam in exams {
                if let cat = ExamCategory.category(for: exam.type) {
                    counts[cat.rawValue, default: 0] += 1
                } else {
                    unmapped.append(exam.type)
                }
            }
            state.examCountsByCategory = counts
            log.info("📋 [VM] load() ✅ \(exams.count) exams — counts=\(counts)")
            if !unmapped.isEmpty {
                log.warning("📋 [VM] \(unmapped.count) exams have UNMAPPED types (won't appear under any category): \(unmapped)")
            }
        case .failure(let err):
            log.error("📋 [VM] load() ❌ \(String(describing: err))")
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
