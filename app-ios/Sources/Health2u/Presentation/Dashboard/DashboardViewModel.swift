import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "DashboardVM")

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public var state = DashboardState()

    private let userRepository: any UserRepository
    private let examRepository: (any ExamRepository)?
    private let onSessionExpired: (() -> Void)?

    public init(
        userRepository: any UserRepository,
        examRepository: (any ExamRepository)? = nil,
        onSessionExpired: (() -> Void)? = nil
    ) {
        self.userRepository = userRepository
        self.examRepository = examRepository
        self.onSessionExpired = onSessionExpired
    }

    public func load() async {
        log.info("Dashboard loading")
        state.isLoading = true
        state.error = nil

        let result = await userRepository.getProfile()
        if case .success(let user) = result {
            state.userName = user.name
            log.info("Dashboard profile loaded: \(user.name)")
        } else if case .failure(let err) = result {
            if case .unauthorized = err {
                log.error("Dashboard session expired")
                onSessionExpired?()
                return
            }
            state.error = "Failed to load."
        }

        if let examRepository {
            let examsResult = await examRepository.getExams(filter: nil)
            if case .success(let exams) = examsResult {
                state.latestBiomarkers = Self.aggregateBiomarkers(exams: exams)
                log.info("Dashboard biomarkers aggregated: \(self.state.latestBiomarkers.count)")
            }
        }

        state.isLoading = false
    }

    // MARK: - Biomarker aggregation

    static func aggregateBiomarkers(exams: [Exam]) -> [ExamBiomarker.Kind: ExamBiomarker] {
        var latest: [ExamBiomarker.Kind: ExamBiomarker] = [:]
        let sorted = exams.sorted { $0.date > $1.date }
        for exam in sorted {
            guard let analysis = exam.analysis,
                  analysis.documentType == "lab_results" else { continue }
            guard case let .labResults(labResults) = analysis.extractedData else { continue }
            for labResult in labResults.results {
                guard let kind = classifyBiomarker(labResult.testName) else { continue }
                if latest[kind] == nil {
                    latest[kind] = ExamBiomarker(
                        kind: kind,
                        value: labResult.value,
                        unit: labResult.unit,
                        flag: labResult.flag,
                        sourceExamId: exam.id,
                        examDate: exam.date
                    )
                }
            }
        }
        return latest
    }

    private static func classifyBiomarker(_ testName: String) -> ExamBiomarker.Kind? {
        let name = testName.lowercased()
        if name.contains("glucose") || name.contains("glic") || name.contains("glyc") || name.contains("blood sugar") {
            return .bloodSugar
        }
        if name.contains("cholesterol") || name.contains("colesterol") {
            return .cholesterol
        }
        if name.contains("pressure") || name.contains("pressão") || name.contains("pressao") || name.contains("tension") {
            return .bloodPressure
        }
        if name.contains("heart rate") || name.contains("pulse") || name.contains("frequência cardíaca") || name.contains("frequencia cardiaca") {
            return .heartRate
        }
        if name.contains("spo2") || name.contains("saturation") || name.contains("saturação") || name.contains("saturacao") {
            return .spo2
        }
        return nil
    }
}
