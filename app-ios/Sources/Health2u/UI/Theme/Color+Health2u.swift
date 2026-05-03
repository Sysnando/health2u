import SwiftUI

// MARK: - MD3 Color System (Stitch Design System)

public extension Color {
    // MARK: - Primary

    static let primary = Color(hex: 0x00020A)
    static let primaryContainer = Color(hex: 0x001B44)
    static let onPrimary = Color.white
    static let onPrimaryContainer = Color(hex: 0x7084B3)

    // MARK: - Secondary

    static let secondary = Color(hex: 0x0058BC)
    static let secondaryContainer = Color(hex: 0x0070EB)
    static let onSecondary = Color.white
    static let onSecondaryContainer = Color(hex: 0xFEFCFF)
    static let secondaryFixed = Color(hex: 0xD8E2FF)
    static let secondaryFixedDim = Color(hex: 0xADC6FF)

    // MARK: - Tertiary

    static let tertiary = Color(hex: 0x000301)
    static let tertiaryContainer = Color(hex: 0x002214)
    static let onTertiary = Color.white
    static let onTertiaryContainer = Color(hex: 0x009768)
    static let tertiaryFixed = Color(hex: 0x6FFBBE)
    static let tertiaryFixedDim = Color(hex: 0x4EDEA3)

    // MARK: - Background & Surface

    static let background = Color(hex: 0xF7F9FB)
    static let onBackground = Color(hex: 0x191C1E)
    static let surface = Color(hex: 0xF7F9FB)
    static let onSurface = Color(hex: 0x191C1E)
    static let onSurfaceVariant = Color(hex: 0x44474F)
    static let surfaceContainerLowest = Color.white
    static let surfaceContainerLow = Color(hex: 0xF2F4F6)
    static let surfaceContainer = Color(hex: 0xECEEF0)
    static let surfaceContainerHigh = Color(hex: 0xE6E8EA)
    static let surfaceContainerHighest = Color(hex: 0xE0E3E5)
    static let surfaceVariant = Color(hex: 0xE0E3E5)
    static let surfaceDim = Color(hex: 0xD8DADC)
    static let surfaceBright = Color(hex: 0xF7F9FB)
    static let surfaceTint = Color(hex: 0x495E8A)

    // MARK: - Outline

    static let outline = Color(hex: 0x75777F)
    static let outlineVariant = Color(hex: 0xC5C6D0)

    // MARK: - Error

    static let error = Color(hex: 0xBA1A1A)
    static let errorContainer = Color(hex: 0xFFDAD6)
    static let onError = Color.white
    static let onErrorContainer = Color(hex: 0x93000A)

    // MARK: - Inverse

    static let inverseSurface = Color(hex: 0x2D3133)
    static let inverseOnSurface = Color(hex: 0xEFF1F3)
    static let inversePrimary = Color(hex: 0xB1C6F9)

    // MARK: - Extended Status Colors

    static let successGreen = Color(hex: 0x009768)
    static let warningOrange = Color(hex: 0xF57C00)
    static let infoBlue = Color(hex: 0x0288D1)

    static let successContainer = Color(red: 200 / 255, green: 230 / 255, blue: 201 / 255)
    static let onSuccessContainer = Color(red: 27 / 255, green: 94 / 255, blue: 32 / 255)
    static let warningContainer = Color(red: 255 / 255, green: 224 / 255, blue: 178 / 255)
    static let onWarningContainer = Color(red: 230 / 255, green: 81 / 255, blue: 0 / 255)
    static let infoContainer = Color(red: 179 / 255, green: 229 / 255, blue: 252 / 255)
    static let onInfoContainer = Color(red: 1 / 255, green: 87 / 255, blue: 155 / 255)

    // MARK: - Legacy Aliases (backward compatibility)

    static let primaryBlue = Color.secondary
    static let primaryBlueDark = Color.primary
    static let primaryBlueLight = Color.secondaryContainer
    static let secondaryTeal = Color.tertiaryFixedDim
    static let secondaryTealDark = Color.tertiaryContainer
    static let secondaryTealLight = Color.tertiaryFixed
    static let tertiaryPurple = Color.surfaceTint
    static let errorRed = Color.error
    static let errorRedDark = Color.onErrorContainer
    static let textPrimary = Color.onSurface
    static let textSecondary = Color.onSurfaceVariant
    static let neutralGray50 = Color.surfaceBright
    static let neutralGray100 = Color.surfaceContainerLow
    static let neutralGray200 = Color.surfaceContainer
    static let neutralGray300 = Color.surfaceContainerHigh
    static let neutralGray400 = Color.outlineVariant
    static let neutralGray500 = Color.outline
    static let neutralGray600 = Color.onSurfaceVariant
    static let neutralGray700 = Color(hex: 0x616161)
    static let neutralGray800 = Color(hex: 0x424242)
    static let neutralGray900 = Color(hex: 0x212121)

    // MARK: - Chart Colors

    static let chart1 = Color.secondary
    static let chart2 = Color.tertiaryFixedDim
    static let chart3 = Color.surfaceTint
    static let chart4 = Color(red: 255 / 255, green: 111 / 255, blue: 0 / 255)
    static let chart5 = Color.error
    static let chart6 = Color.successGreen

    // MARK: - Health Metric Colors

    static let bloodPressure = Color(red: 233 / 255, green: 30 / 255, blue: 99 / 255)
    static let heartRate = Color.error
    static let bloodSugar = Color.surfaceTint
    static let weight = Color.tertiaryFixedDim
    static let temperature = Color.warningOrange
    static let oxygen = Color(red: 33 / 255, green: 150 / 255, blue: 243 / 255)
}

// MARK: - Hex Color Initializer

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
