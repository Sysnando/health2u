import SwiftUI

public struct HealthSummaryCard: View {
    let title: String
    let value: String
    let unit: String
    let trend: String?
    let icon: String

    public init(
        title: String,
        value: String,
        unit: String,
        trend: String? = nil,
        icon: String = "heart.fill"
    ) {
        self.title = title
        self.value = value
        self.unit = unit
        self.trend = trend
        self.icon = icon
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.secondary)

            Text(title)
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)

            HStack(alignment: .lastTextBaseline, spacing: Dimensions.Space.xs) {
                Text(value)
                    .font(Typography.healthMetricMedium)
                    .foregroundColor(.onSurface)
                Text(unit)
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
            }

            if let trend {
                HStack(spacing: Dimensions.Space.xxs) {
                    Image(systemName: trendArrow(for: trend))
                        .font(.system(size: 10, weight: .bold))
                    Text(trend)
                        .font(Typography.labelSmall)
                }
                .foregroundColor(.tertiaryFixedDim)
            }
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xxl))
        .overlay(
            RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xxl)
                .stroke(Color.outlineVariant.opacity(0.1), lineWidth: 1)
        )
    }

    private func trendArrow(for trend: String) -> String {
        let lower = trend.lowercased()
        if lower.contains("up") || lower.contains("high") {
            return "arrow.up.right"
        } else if lower.contains("down") || lower.contains("low") {
            return "arrow.down.right"
        }
        return "arrow.right"
    }
}
