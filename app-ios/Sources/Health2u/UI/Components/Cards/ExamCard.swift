import SwiftUI

public struct ExamCard: View {
    let title: String
    let type: String
    let date: Date
    let onTap: () -> Void

    public init(title: String, type: String, date: Date, onTap: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.date = date
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Left color accent bar
                accentColor
                    .frame(width: 4)

                HStack(spacing: Dimensions.Space.m) {
                    // Colored icon circle
                    ZStack {
                        Circle()
                            .fill(accentColor.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: iconName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(accentColor)
                    }

                    VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                        Text(title)
                            .font(Typography.titleMedium)
                            .foregroundColor(.onSurface)
                        Text(type)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                        Text(formattedDate)
                            .font(Typography.labelSmall)
                            .foregroundColor(.outline)
                    }

                    Spacer()

                    Text("View Report")
                        .font(Typography.labelMedium)
                        .foregroundColor(.secondary)
                }
                .padding(Dimensions.Space.m)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                    .stroke(Color.outlineVariant.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var accentColor: Color {
        let lower = type.lowercased()
        if lower.contains("blood") {
            return .bloodPressure
        } else if lower.contains("cardio") || lower.contains("heart") {
            return .heartRate
        } else if lower.contains("urin") || lower.contains("kidney") {
            return .warningOrange
        }
        return .secondary
    }

    private var iconName: String {
        let lower = type.lowercased()
        if lower.contains("blood") {
            return "drop.fill"
        } else if lower.contains("cardio") || lower.contains("heart") {
            return "heart.fill"
        } else if lower.contains("xray") || lower.contains("x-ray") || lower.contains("imaging") {
            return "xray"
        }
        return "doc.text.fill"
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
