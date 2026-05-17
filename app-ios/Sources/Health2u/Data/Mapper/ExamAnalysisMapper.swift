import Foundation

// MARK: - Status mapping (defensive)

private func mapStatus(_ raw: String) -> ExamAnalysis.Status {
    switch raw {
    case "processing": return .processing
    case "completed": return .completed
    case "failed": return .failed
    default: return .failed
    }
}

// MARK: - DTO -> Domain

extension ExamAnalysisDTO {
    public func toDomain() -> ExamAnalysis {
        ExamAnalysis(
            id: id,
            examId: examId,
            status: mapStatus(status),
            documentType: documentType,
            summary: summary,
            language: language,
            modelUsed: modelUsed,
            errorMessage: errorMessage,
            extractedData: extractedData?.toDomain() ?? .unknown
        )
    }

    public func toEntity() -> ExamAnalysisEntity {
        ExamAnalysisEntity(
            id: id,
            examId: examId,
            status: status,
            documentType: documentType,
            summary: summary,
            language: language,
            modelUsed: modelUsed,
            errorMessage: errorMessage,
            extractedData: extractedData?.toEntity() ?? .unknown
        )
    }
}

extension ExtractedDataDTO {
    public func toDomain() -> ExtractedData {
        switch self {
        case .labResults(let v):
            return .labResults(LabResults(
                patientName: v.patientName,
                testDate: v.testDate,
                labName: v.labName,
                results: (v.results ?? []).map {
                    LabResult(
                        testName: $0.testName,
                        value: $0.value.stringValue,
                        unit: $0.unit,
                        referenceRange: $0.referenceRange,
                        flag: $0.flag
                    )
                }
            ))
        case .prescription(let v):
            return .prescription(Prescription(
                prescriber: v.prescriber,
                date: v.date,
                medications: (v.medications ?? []).map {
                    Medication(
                        name: $0.name,
                        dosage: $0.dosage,
                        frequency: $0.frequency,
                        duration: $0.duration
                    )
                }
            ))
        case .imagingReport(let v):
            return .imagingReport(ImagingReport(
                modality: v.modality,
                bodyPart: v.bodyPart,
                findings: v.findings,
                impression: v.impression
            ))
        case .other(let content):
            return .other(content: content)
        case .unknown:
            return .unknown
        }
    }

    public func toEntity() -> ExtractedDataEntity {
        switch self {
        case .labResults(let v):
            return .labResults(LabResultsEntity(
                patientName: v.patientName,
                testDate: v.testDate,
                labName: v.labName,
                results: (v.results ?? []).map {
                    LabResultRow(
                        testName: $0.testName,
                        value: $0.value.stringValue,
                        unit: $0.unit,
                        referenceRange: $0.referenceRange,
                        flag: $0.flag
                    )
                }
            ))
        case .prescription(let v):
            return .prescription(PrescriptionEntity(
                prescriber: v.prescriber,
                date: v.date,
                medications: (v.medications ?? []).map {
                    MedicationEntity(
                        name: $0.name,
                        dosage: $0.dosage,
                        frequency: $0.frequency,
                        duration: $0.duration
                    )
                }
            ))
        case .imagingReport(let v):
            return .imagingReport(ImagingReportEntity(
                modality: v.modality,
                bodyPart: v.bodyPart,
                findings: v.findings,
                impression: v.impression
            ))
        case .other(let content):
            return .other(content: content)
        case .unknown:
            return .unknown
        }
    }
}

// MARK: - Domain -> DTO

extension ExamAnalysis {
    public func toDTO() -> ExamAnalysisDTO {
        ExamAnalysisDTO(
            id: id,
            examId: examId,
            userId: "",
            status: status.rawValue,
            documentType: documentType,
            summary: summary,
            language: language,
            extractedData: extractedData.toDTO(),
            modelUsed: modelUsed,
            errorMessage: errorMessage,
            createdAt: Date(timeIntervalSince1970: 0),
            updatedAt: Date(timeIntervalSince1970: 0)
        )
    }
}

extension ExtractedData {
    public func toDTO() -> ExtractedDataDTO? {
        switch self {
        case .labResults(let v):
            return .labResults(LabResultsDTO(
                patientName: v.patientName,
                testDate: v.testDate,
                labName: v.labName,
                results: v.results.map {
                    LabResultDTO(
                        testName: $0.testName,
                        value: LabResultDTO.ValueDTO(stringValue: $0.value),
                        unit: $0.unit,
                        referenceRange: $0.referenceRange,
                        flag: $0.flag
                    )
                }
            ))
        case .prescription(let v):
            return .prescription(PrescriptionDTO(
                prescriber: v.prescriber,
                date: v.date,
                medications: v.medications.map {
                    MedicationDTO(
                        name: $0.name,
                        dosage: $0.dosage,
                        frequency: $0.frequency,
                        duration: $0.duration
                    )
                }
            ))
        case .imagingReport(let v):
            return .imagingReport(ImagingReportDTO(
                modality: v.modality,
                bodyPart: v.bodyPart,
                findings: v.findings,
                impression: v.impression
            ))
        case .other(let content):
            return .other(content: content)
        case .unknown:
            return .unknown
        }
    }
}

// MARK: - Domain -> Entity

extension ExamAnalysis {
    public func toEntity() -> ExamAnalysisEntity {
        ExamAnalysisEntity(
            id: id,
            examId: examId,
            status: status.rawValue,
            documentType: documentType,
            summary: summary,
            language: language,
            modelUsed: modelUsed,
            errorMessage: errorMessage,
            extractedData: extractedData.toEntity()
        )
    }
}

extension ExtractedData {
    public func toEntity() -> ExtractedDataEntity {
        switch self {
        case .labResults(let v):
            return .labResults(LabResultsEntity(
                patientName: v.patientName,
                testDate: v.testDate,
                labName: v.labName,
                results: v.results.map {
                    LabResultRow(
                        testName: $0.testName,
                        value: $0.value,
                        unit: $0.unit,
                        referenceRange: $0.referenceRange,
                        flag: $0.flag
                    )
                }
            ))
        case .prescription(let v):
            return .prescription(PrescriptionEntity(
                prescriber: v.prescriber,
                date: v.date,
                medications: v.medications.map {
                    MedicationEntity(
                        name: $0.name,
                        dosage: $0.dosage,
                        frequency: $0.frequency,
                        duration: $0.duration
                    )
                }
            ))
        case .imagingReport(let v):
            return .imagingReport(ImagingReportEntity(
                modality: v.modality,
                bodyPart: v.bodyPart,
                findings: v.findings,
                impression: v.impression
            ))
        case .other(let content):
            return .other(content: content)
        case .unknown:
            return .unknown
        }
    }
}

// MARK: - Entity -> Domain

extension ExamAnalysisEntity {
    public func toDomain() -> ExamAnalysis {
        ExamAnalysis(
            id: id,
            examId: examId,
            status: mapStatus(status),
            documentType: documentType,
            summary: summary,
            language: language,
            modelUsed: modelUsed,
            errorMessage: errorMessage,
            extractedData: extractedData.toDomain()
        )
    }
}

extension ExtractedDataEntity {
    public func toDomain() -> ExtractedData {
        switch self {
        case .labResults(let v):
            return .labResults(LabResults(
                patientName: v.patientName,
                testDate: v.testDate,
                labName: v.labName,
                results: v.results.map {
                    LabResult(
                        testName: $0.testName,
                        value: $0.value,
                        unit: $0.unit,
                        referenceRange: $0.referenceRange,
                        flag: $0.flag
                    )
                }
            ))
        case .prescription(let v):
            return .prescription(Prescription(
                prescriber: v.prescriber,
                date: v.date,
                medications: v.medications.map {
                    Medication(
                        name: $0.name,
                        dosage: $0.dosage,
                        frequency: $0.frequency,
                        duration: $0.duration
                    )
                }
            ))
        case .imagingReport(let v):
            return .imagingReport(ImagingReport(
                modality: v.modality,
                bodyPart: v.bodyPart,
                findings: v.findings,
                impression: v.impression
            ))
        case .other(let content):
            return .other(content: content)
        case .unknown:
            return .unknown
        }
    }
}
