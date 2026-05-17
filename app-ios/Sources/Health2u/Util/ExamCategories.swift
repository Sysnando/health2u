import Foundation

public enum ExamCategory: String, CaseIterable, Identifiable, Sendable {
    case lab = "lab"
    case imaging = "imaging"
    case cardioFunctional = "cardio_functional"
    case preventiveScreening = "preventive_screening"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .lab: return "drop.fill"
        case .imaging: return "rays"
        case .cardioFunctional: return "heart.fill"
        case .preventiveScreening: return "shield.checkered"
        }
    }

    public var subcategories: [String] {
        switch self {
        case .lab: return ["Hemograma", "Bioquímica", "Urina", "Fezes"]
        case .imaging: return ["Raio-X", "Ultrassom", "Ressonância Magnética", "Tomografia", "Mamografia"]
        case .cardioFunctional: return ["ECG", "Teste de Esforço", "Holter", "Espirometria"]
        case .preventiveScreening: return ["Papanicolau", "Colonoscopia", "Próstata", "Densitometria Óssea"]
        }
    }

    public static func category(for examType: String) -> ExamCategory? {
        for cat in allCases {
            if cat.subcategories.contains(examType) { return cat }
        }
        switch examType.lowercased() {
        case "labs", "lab results": return .lab
        case "imaging", "radiology": return .imaging
        case "cardiology": return .cardioFunctional
        case "general": return nil
        default: return nil
        }
    }

    public var localizationKey: String {
        switch self {
        case .lab: return "exam_category.lab"
        case .imaging: return "exam_category.imaging"
        case .cardioFunctional: return "exam_category.cardio_functional"
        case .preventiveScreening: return "exam_category.preventive_screening"
        }
    }

    public var descriptionKey: String {
        switch self {
        case .lab: return "exam_category.lab_description"
        case .imaging: return "exam_category.imaging_description"
        case .cardioFunctional: return "exam_category.cardio_functional_description"
        case .preventiveScreening: return "exam_category.preventive_screening_description"
        }
    }
}
