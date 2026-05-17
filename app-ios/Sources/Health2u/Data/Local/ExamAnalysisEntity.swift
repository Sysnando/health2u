import Foundation

public struct ExamAnalysisEntity: Sendable, Equatable, Identifiable {
    public let id: String
    public var examId: String
    public var status: String
    public var documentType: String?
    public var summary: String?
    public var language: String?
    public var modelUsed: String?
    public var errorMessage: String?
    public var extractedData: ExtractedDataEntity

    public init(
        id: String,
        examId: String,
        status: String,
        documentType: String? = nil,
        summary: String? = nil,
        language: String? = nil,
        modelUsed: String? = nil,
        errorMessage: String? = nil,
        extractedData: ExtractedDataEntity = .unknown
    ) {
        self.id = id
        self.examId = examId
        self.status = status
        self.documentType = documentType
        self.summary = summary
        self.language = language
        self.modelUsed = modelUsed
        self.errorMessage = errorMessage
        self.extractedData = extractedData
    }
}

public enum ExtractedDataEntity: Equatable, Sendable {
    case labResults(LabResultsEntity)
    case prescription(PrescriptionEntity)
    case imagingReport(ImagingReportEntity)
    case other(content: String?)
    case unknown
}

public struct LabResultsEntity: Sendable, Equatable {
    public let patientName: String?
    public let testDate: String?
    public let labName: String?
    public let results: [LabResultRow]

    public init(
        patientName: String? = nil,
        testDate: String? = nil,
        labName: String? = nil,
        results: [LabResultRow] = []
    ) {
        self.patientName = patientName
        self.testDate = testDate
        self.labName = labName
        self.results = results
    }
}

public struct LabResultRow: Sendable, Equatable {
    public let testName: String
    public let value: String
    public let unit: String?
    public let referenceRange: String?
    public let flag: String?

    public init(
        testName: String,
        value: String,
        unit: String? = nil,
        referenceRange: String? = nil,
        flag: String? = nil
    ) {
        self.testName = testName
        self.value = value
        self.unit = unit
        self.referenceRange = referenceRange
        self.flag = flag
    }
}

public struct PrescriptionEntity: Sendable, Equatable {
    public let prescriber: String?
    public let date: String?
    public let medications: [MedicationEntity]

    public init(prescriber: String? = nil, date: String? = nil, medications: [MedicationEntity] = []) {
        self.prescriber = prescriber
        self.date = date
        self.medications = medications
    }
}

public struct MedicationEntity: Sendable, Equatable {
    public let name: String
    public let dosage: String?
    public let frequency: String?
    public let duration: String?

    public init(name: String, dosage: String? = nil, frequency: String? = nil, duration: String? = nil) {
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.duration = duration
    }
}

public struct ImagingReportEntity: Sendable, Equatable {
    public let modality: String?
    public let bodyPart: String?
    public let findings: String?
    public let impression: String?

    public init(
        modality: String? = nil,
        bodyPart: String? = nil,
        findings: String? = nil,
        impression: String? = nil
    ) {
        self.modality = modality
        self.bodyPart = bodyPart
        self.findings = findings
        self.impression = impression
    }
}
