import Foundation

@MainActor
public final class MyHealthViewModel: ObservableObject {
    @Published public var state = MyHealthState()
    private let examRepository: any ExamRepository

    public init(examRepository: any ExamRepository) {
        self.examRepository = examRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil
        let result = await examRepository.getExams(filter: nil)
        switch result {
        case .success(let exams):
            let calendar = Calendar.current
            var yearCounts: [Int: Int] = [:]
            var yearAiCounts: [Int: Int] = [:]
            for exam in exams {
                let year = calendar.component(.year, from: exam.date)
                yearCounts[year, default: 0] += 1
                if exam.analysis?.status == .completed && exam.analysis?.summary != nil {
                    yearAiCounts[year, default: 0] += 1
                }
            }
            state.years = yearCounts.map { entry in
                HealthYear(
                    year: entry.key,
                    examCount: entry.value,
                    color: .green,
                    aiAnalyzedCount: yearAiCounts[entry.key, default: 0]
                )
            }
            .sorted { $0.year > $1.year }
        case .failure(let err):
            state.error = err == .offline ? "You appear to be offline." : "Failed to load health data."
        }
        state.isLoading = false
    }
}
