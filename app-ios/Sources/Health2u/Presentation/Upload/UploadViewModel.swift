import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "UploadVM")

@MainActor
public final class UploadViewModel: ObservableObject {
    @Published public var state = UploadState()

    private let examRepository: any ExamRepository
    private let onUploaded: (@MainActor () -> Void)?

    public init(
        examRepository: any ExamRepository,
        onUploaded: (@MainActor () -> Void)? = nil
    ) {
        self.examRepository = examRepository
        self.onUploaded = onUploaded
    }

    public func load() async {
        // No initial load needed
    }

    public func upload() async {
        let t0 = Date()
        log.info("📤 [VM] Upload started at \(t0.timeIntervalSince1970)")
        state.isUploading = true
        state.error = nil
        state.skippedReason = nil

        let effectiveTitle = state.title.isEmpty ? "Untitled Exam" : state.title

        let metadata = ExamUploadMetadata(
            title: effectiveTitle,
            type: state.type,
            date: state.date,
            notes: state.notes.isEmpty ? nil : state.notes
        )

        let fileData: Data
        let filename: String

        if let imageData = state.imageData {
            fileData = imageData
            filename = "photo-capture.jpg"
            log.info("📤 [VM] Using captured image — \(imageData.count) bytes")
        } else if let pickedData = state.fileData, let pickedName = state.filename {
            fileData = pickedData
            filename = pickedName
            log.info("📤 [VM] Using picked file — name=\(pickedName), \(pickedData.count) bytes")
        } else {
            log.warning("📤 [VM] Upload blocked — no file selected")
            state.error = "Please select a file or take a photo."
            state.isUploading = false
            return
        }

        log.info("📤 [VM] Calling repository.uploadExam — title='\(effectiveTitle)' type='\(self.state.type)' filename=\(filename) size=\(fileData.count)")
        let result = await examRepository.uploadExam(
            metadata: metadata,
            fileData: fileData,
            filename: filename
        )
        let elapsed = Date().timeIntervalSince(t0)
        log.info("📤 [VM] repository.uploadExam returned after \(String(format: "%.2f", elapsed))s")

        switch result {
        case .success(let exam):
            log.info("📤 [VM] ✅ Upload succeeded — examId=\(exam.id) title='\(exam.title)' type='\(exam.type)' analysisStatus=\(exam.analysis?.status.rawValue ?? "nil")")
            state.didSucceed = true
            if onUploaded == nil {
                log.warning("📤 [VM] onUploaded callback is nil — list will NOT refresh from VM")
            } else {
                log.info("📤 [VM] Firing onUploaded callback")
            }
            onUploaded?()
        case .failure(let err):
            log.error("📤 [VM] ❌ Upload failed after \(String(format: "%.2f", elapsed))s: \(String(describing: err))")
            if case .notAMedicalDocument(let reason) = err {
                log.warning("📤 [VM] Server rejected as non-medical — reason='\(reason)'")
                state.skippedReason = reason
                state.imageData = nil
                state.fileData = nil
                state.filename = nil
            } else {
                state.error = Self.errorMessage(err)
            }
        }

        state.isUploading = false
        log.info("📤 [VM] upload() complete (state.didSucceed=\(self.state.didSucceed), state.error=\(self.state.error ?? "nil"), state.skippedReason=\(self.state.skippedReason ?? "nil"))")
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Upload failed."
        }
    }
}
