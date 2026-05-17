import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "ExamAnalysisDTO")

public struct ExamAnalysisDTO: Codable, Equatable, Sendable {
    public let id: String
    public let examId: String
    public let userId: String
    public let status: String
    public let documentType: String?
    public let summary: String?
    public let language: String?
    public let extractedData: ExtractedDataDTO?
    public let modelUsed: String?
    public let errorMessage: String?
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        examId: String,
        userId: String,
        status: String,
        documentType: String?,
        summary: String?,
        language: String?,
        extractedData: ExtractedDataDTO?,
        modelUsed: String?,
        errorMessage: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.examId = examId
        self.userId = userId
        self.status = status
        self.documentType = documentType
        self.summary = summary
        self.language = language
        self.extractedData = extractedData
        self.modelUsed = modelUsed
        self.errorMessage = errorMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Polymorphic container for the `extracted_data` field. The concrete shape is
/// dictated by the surrounding `document_type`. Decoding is best-effort: when a
/// typed decode fails we fall back to `.unknown` rather than throwing.
public enum ExtractedDataDTO: Equatable, Sendable {
    case labResults(LabResultsDTO)
    case prescription(PrescriptionDTO)
    case imagingReport(ImagingReportDTO)
    case other(content: String?)
    case unknown
}

public struct LabResultsDTO: Codable, Equatable, Sendable {
    public let patientName: String?
    public let testDate: String?
    public let labName: String?
    public let results: [LabResultDTO]?
}

public struct LabResultDTO: Codable, Equatable, Sendable {
    public let testName: String
    public let value: ValueDTO
    public let unit: String?
    public let referenceRange: String?
    public let flag: String?

    /// Tolerant value decoder — backend may send either a string or a number.
    public struct ValueDTO: Codable, Equatable, Sendable {
        public let stringValue: String

        public init(stringValue: String) { self.stringValue = stringValue }

        public init(from decoder: Decoder) throws {
            let c = try decoder.singleValueContainer()
            if let s = try? c.decode(String.self) {
                stringValue = s
            } else if let d = try? c.decode(Double.self) {
                if d.truncatingRemainder(dividingBy: 1) == 0 {
                    stringValue = String(Int64(d))
                } else {
                    stringValue = String(d)
                }
            } else if let i = try? c.decode(Int64.self) {
                stringValue = String(i)
            } else if let b = try? c.decode(Bool.self) {
                stringValue = String(b)
            } else {
                stringValue = ""
            }
        }

        public func encode(to encoder: Encoder) throws {
            var c = encoder.singleValueContainer()
            try c.encode(stringValue)
        }
    }
}

public struct PrescriptionDTO: Codable, Equatable, Sendable {
    public let prescriber: String?
    public let date: String?
    public let medications: [MedicationDTO]?
}

public struct MedicationDTO: Codable, Equatable, Sendable {
    public let name: String
    public let dosage: String?
    public let frequency: String?
    public let duration: String?
}

public struct ImagingReportDTO: Codable, Equatable, Sendable {
    public let modality: String?
    public let bodyPart: String?
    public let findings: String?
    public let impression: String?
}

public struct OtherExtractedDTO: Codable, Equatable, Sendable {
    public let content: String?
}

// MARK: - Polymorphic Codable for the analysis DTO

extension ExamAnalysisDTO {
    private enum CodingKeys: String, CodingKey {
        case id, examId, userId, status, documentType, summary, language
        case extractedData, modelUsed, errorMessage, createdAt, updatedAt
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        examId = try c.decode(String.self, forKey: .examId)
        userId = try c.decode(String.self, forKey: .userId)
        status = try c.decode(String.self, forKey: .status)
        documentType = try c.decodeIfPresent(String.self, forKey: .documentType)
        summary = try c.decodeIfPresent(String.self, forKey: .summary)
        language = try c.decodeIfPresent(String.self, forKey: .language)
        modelUsed = try c.decodeIfPresent(String.self, forKey: .modelUsed)
        errorMessage = try c.decodeIfPresent(String.self, forKey: .errorMessage)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        updatedAt = try c.decode(Date.self, forKey: .updatedAt)

        // Polymorphic decode driven by document_type. If the typed shape
        // fails to parse (malformed AI response), gracefully fall back to
        // .unknown rather than failing the whole DTO.
        if c.contains(.extractedData), try c.decodeNil(forKey: .extractedData) == false {
            extractedData = Self.decodeExtractedData(
                from: c,
                key: .extractedData,
                documentType: documentType
            )
        } else {
            extractedData = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(examId, forKey: .examId)
        try c.encode(userId, forKey: .userId)
        try c.encode(status, forKey: .status)
        try c.encodeIfPresent(documentType, forKey: .documentType)
        try c.encodeIfPresent(summary, forKey: .summary)
        try c.encodeIfPresent(language, forKey: .language)
        try c.encodeIfPresent(modelUsed, forKey: .modelUsed)
        try c.encodeIfPresent(errorMessage, forKey: .errorMessage)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)

        guard let extractedData else { return }
        switch extractedData {
        case .labResults(let v):
            try c.encode(v, forKey: .extractedData)
        case .prescription(let v):
            try c.encode(v, forKey: .extractedData)
        case .imagingReport(let v):
            try c.encode(v, forKey: .extractedData)
        case .other(let content):
            try c.encode(OtherExtractedDTO(content: content), forKey: .extractedData)
        case .unknown:
            break
        }
    }

    private static func decodeExtractedData(
        from container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys,
        documentType: String?
    ) -> ExtractedDataDTO? {
        switch documentType {
        case "lab_results":
            if let v = try? container.decode(LabResultsDTO.self, forKey: key) {
                return .labResults(v)
            }
            log.warning("Failed to decode lab_results extracted_data; falling back to .unknown")
            return .unknown
        case "prescription":
            if let v = try? container.decode(PrescriptionDTO.self, forKey: key) {
                return .prescription(v)
            }
            log.warning("Failed to decode prescription extracted_data; falling back to .unknown")
            return .unknown
        case "imaging_report":
            if let v = try? container.decode(ImagingReportDTO.self, forKey: key) {
                return .imagingReport(v)
            }
            log.warning("Failed to decode imaging_report extracted_data; falling back to .unknown")
            return .unknown
        case "other":
            if let v = try? container.decode(OtherExtractedDTO.self, forKey: key) {
                return .other(content: v.content)
            }
            // Backend may send a bare string or empty object for "other".
            if let s = try? container.decode(String.self, forKey: key) {
                return .other(content: s)
            }
            return .other(content: nil)
        default:
            return .unknown
        }
    }
}
