import Foundation

public struct ExamAnalysis: Identifiable, Equatable, Sendable {
    public enum Status: String, Sendable, Equatable {
        case processing
        case completed
        case failed
    }

    public let id: String
    public let examId: String
    public let status: Status
    public let documentType: String?
    public let summary: String?
    public let language: String?
    public let modelUsed: String?
    public let errorMessage: String?
    public let extractedData: ExtractedData

    public init(
        id: String,
        examId: String,
        status: Status,
        documentType: String? = nil,
        summary: String? = nil,
        language: String? = nil,
        modelUsed: String? = nil,
        errorMessage: String? = nil,
        extractedData: ExtractedData = .unknown
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

public enum ExtractedData: Equatable, Sendable {
    case labResults(LabResults)
    case prescription(Prescription)
    case imagingReport(ImagingReport)
    case other(content: String?)
    case unknown
}

public struct LabResults: Equatable, Sendable {
    public let patientName: String?
    public let testDate: String?
    public let labName: String?
    public let results: [LabResult]

    public init(
        patientName: String? = nil,
        testDate: String? = nil,
        labName: String? = nil,
        results: [LabResult] = []
    ) {
        self.patientName = patientName
        self.testDate = testDate
        self.labName = labName
        self.results = results
    }
}

public struct LabResult: Equatable, Sendable {
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

public struct Prescription: Equatable, Sendable {
    public let prescriber: String?
    public let date: String?
    public let medications: [Medication]

    public init(prescriber: String? = nil, date: String? = nil, medications: [Medication] = []) {
        self.prescriber = prescriber
        self.date = date
        self.medications = medications
    }
}

public struct Medication: Equatable, Sendable {
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

public struct ImagingReport: Equatable, Sendable {
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
