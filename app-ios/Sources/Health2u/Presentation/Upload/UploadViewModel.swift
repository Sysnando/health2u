import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "UploadVM")

@MainActor
public final class UploadViewModel: ObservableObject {
    @Published public var state = UploadState()

    private let examRepository: any ExamRepository

    public init(examRepository: any ExamRepository) {
        self.examRepository = examRepository
    }

    public func load() async {
        // No initial load needed
    }

    public func upload() async {
        log.info("📤 Upload started")
        state.isUploading = true
        state.error = nil

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
        } else if let pickedData = state.fileData, let pickedName = state.filename {
            fileData = pickedData
            filename = pickedName
        } else {
            log.warning("📤 Upload blocked — no file selected")
            state.error = "Please select a file or take a photo."
            state.isUploading = false
            return
        }

        log.info("📤 Uploading '\(effectiveTitle)' (\(filename), \(fileData.count) bytes)")
        let result = await examRepository.uploadExam(
            metadata: metadata,
            fileData: fileData,
            filename: filename
        )

        switch result {
        case .success:
            log.info("📤 Upload succeeded")
            state.didSucceed = true
        case .failure(let err):
            log.error("📤 Upload failed: \(String(describing: err))")
            state.error = Self.errorMessage(err)
        }

        state.isUploading = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "Upload failed."
        }
    }
}
