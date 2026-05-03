import SwiftUI

public enum Typography {
    // MARK: - Display

    public static let displayLarge: Font = .system(size: 57, weight: .bold).leading(.tight)
    public static let displayMedium: Font = .system(size: 45, weight: .bold).leading(.tight)
    public static let displaySmall: Font = .system(size: 36, weight: .bold).leading(.tight)

    // MARK: - Headline (bold/heavy, tight tracking)

    public static let headlineLarge: Font = .system(size: 32, weight: .bold)
    public static let headlineMedium: Font = .system(size: 28, weight: .bold)
    public static let headlineSmall: Font = .system(size: 24, weight: .bold)

    // MARK: - Title

    public static let titleLarge: Font = .system(size: 22, weight: .bold)
    public static let titleMedium: Font = .system(size: 16, weight: .semibold)
    public static let titleSmall: Font = .system(size: 14, weight: .medium)

    // MARK: - Body (regular/medium weights)

    public static let bodyLarge: Font = .system(size: 16, weight: .regular)
    public static let bodyMedium: Font = .system(size: 14, weight: .regular)
    public static let bodySmall: Font = .system(size: 12, weight: .regular)

    // MARK: - Label

    public static let labelLarge: Font = .system(size: 14, weight: .medium)
    public static let labelMedium: Font = .system(size: 12, weight: .medium)
    public static let labelSmall: Font = .system(size: 11, weight: .medium)

    // MARK: - Custom

    public static let healthMetricLarge: Font = .system(size: 48, weight: .heavy)
    public static let healthMetricMedium: Font = .system(size: 32, weight: .bold)
    public static let healthMetricLabel: Font = .system(size: 12, weight: .regular)
    public static let caption: Font = .system(size: 10, weight: .regular)
    public static let overline: Font = .system(size: 10, weight: .semibold)
    public static let button: Font = .system(size: 14, weight: .semibold)
    public static let tab: Font = .system(size: 14, weight: .medium)
    public static let input: Font = .system(size: 16, weight: .regular)
    public static let inputLabel: Font = .system(size: 12, weight: .medium)
    public static let error: Font = .system(size: 12, weight: .regular)
}
