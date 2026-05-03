import SwiftUI

public enum AppLanguage: String, CaseIterable, Identifiable {
    case en = "en"
    case es = "es"
    case ptBR = "pt-BR"
    case pt = "pt"
    case fr = "fr"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .en: return "English"
        case .es: return "Espanol"
        case .ptBR: return "Portugues (BR)"
        case .pt: return "Portugues (PT)"
        case .fr: return "Francais"
        }
    }
}

@MainActor
public final class LocalizationManager: ObservableObject {
    @Published public var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
        }
    }

    public static let shared = LocalizationManager()

    private init() {
        let saved = UserDefaults.standard.string(forKey: "app_language") ?? "en"
        self.currentLanguage = AppLanguage(rawValue: saved) ?? .en
    }

    public func string(_ key: String) -> String {
        return LocalizedStrings.strings[currentLanguage]?[key]
            ?? LocalizedStrings.strings[.en]?[key]
            ?? key
    }
}
