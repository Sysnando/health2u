import SwiftUI

public struct InsightsView: View {
    @StateObject private var viewModel: InsightsViewModel

    public init(viewModel: InsightsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.insights.isEmpty {
                LoadingIndicator(message: "Loading insights...")
            } else if let error = viewModel.state.error, viewModel.state.insights.isEmpty {
                EmptyState(
                    icon: "lightbulb",
                    title: "Unable to load insights",
                    message: error,
                    actionTitle: "Retry",
                    action: { Task { await viewModel.load() } }
                )
            } else if viewModel.state.insights.isEmpty {
                EmptyState(
                    icon: "lightbulb",
                    title: "No insights yet",
                    message: "Insights will appear as you add more health data."
                )
            } else {
                content
            }
        }
        .background(Color.background)
        .navigationTitle("Health Insights")
        .task { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.l) {
                // Header
                headerSection

                // Metabolic stability card
                metabolicCard

                // Longevity score banner
                longevityBanner

                // Metric ring section
                metricRingSection

                // Recent reports
                recentReports
            }
            .padding(.vertical, Dimensions.Space.m)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
            HStack {
                Text("2YH")
                    .font(Typography.overline)
                    .foregroundColor(.onSurfaceVariant)
                    .tracking(1.2)
                Spacer()
                Image(systemName: "gearshape")
                    .font(.system(size: 20))
                    .foregroundColor(.onSurfaceVariant)
            }
            Text("Health Insights")
                .font(Typography.headlineLarge)
                .foregroundColor(.primary)

            // Date range selector
            HStack(spacing: Dimensions.Space.s) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                Text(dateRangeText)
                    .font(Typography.labelMedium)
                Image(systemName: "chevron.down")
                    .font(.system(size: 10))
            }
            .foregroundColor(.onSurfaceVariant)
            .padding(.horizontal, Dimensions.Space.m)
            .padding(.vertical, Dimensions.Space.s)
            .background(Color.surfaceContainerLow)
            .cornerRadius(Dimensions.CornerRadius.full)
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    private var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -30, to: end) ?? end
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    // MARK: - Metabolic Card

    private var metabolicCard: some View {
        let grouped = Dictionary(grouping: viewModel.state.insights, by: \.type)
        let metabolicInsights = grouped.first?.value ?? Array(viewModel.state.insights.prefix(3))

        return VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text("Metabolic Stability")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            HStack(spacing: Dimensions.Space.s) {
                ForEach(metabolicInsights.prefix(3)) { insight in
                    metricBadge(insight)
                }
            }
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .shadow(color: .black.opacity(0.04), radius: Dimensions.Elevation.s, x: 0, y: Dimensions.Elevation.xs)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func metricBadge(_ insight: HealthInsight) -> some View {
        let value = insight.metricValue ?? 0
        let color = metricColor(value)
        return VStack(spacing: Dimensions.Space.xs) {
            Text(String(format: "%.1f", value))
                .font(Typography.titleMedium)
                .foregroundColor(color)
            Text(insight.title)
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)
                .lineLimit(1)
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.s)
        .background(color.opacity(0.1))
        .cornerRadius(Dimensions.CornerRadius.m)
    }

    private func metricColor(_ value: Double) -> Color {
        if value > 5 { return .onTertiaryContainer }
        if value > 0 { return .warningOrange }
        return .error
    }

    // MARK: - Longevity Banner

    private var longevityBanner: some View {
        let avgScore = viewModel.state.insights
            .compactMap(\.metricValue)
            .reduce(0, +) / max(Double(viewModel.state.insights.count), 1)

        return HStack {
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Predictive Longevity Score")
                    .font(Typography.titleMedium)
                    .foregroundColor(.surfaceContainerLowest)
                Text("Based on your current health metrics")
                    .font(Typography.bodySmall)
                    .foregroundColor(.surfaceContainerLowest.opacity(0.7))
            }
            Spacer()
            Text(String(format: "%.0f", max(min(avgScore * 10, 100), 0)))
                .font(Typography.healthMetricLarge)
                .foregroundColor(.tertiaryFixed)
        }
        .padding(Dimensions.Space.l)
        .background(
            LinearGradient(
                colors: [.primaryContainer, .primary],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Metric Ring Section

    private var metricRingSection: some View {
        let overallScore = calculateOverallScore()

        return VStack(spacing: Dimensions.Space.m) {
            // Ring chart
            ZStack {
                Circle()
                    .stroke(Color.surfaceContainerHigh, lineWidth: 12)
                    .frame(width: 120, height: 120)
                Circle()
                    .trim(from: 0, to: overallScore / 100)
                    .stroke(Color.secondary, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                Text(String(format: "%.0f", overallScore))
                    .font(Typography.healthMetricLarge)
                    .foregroundColor(.onSurface)
            }

            // Breakdown metrics
            HStack(spacing: Dimensions.Space.l) {
                breakdownMetric(title: "Sleep", icon: "moon.fill", color: .surfaceTint)
                breakdownMetric(title: "Stress", icon: "brain.head.profile", color: .warningOrange)
                breakdownMetric(title: "Activity", icon: "figure.walk", color: .onTertiaryContainer)
                breakdownMetric(title: "Nutrition", icon: "fork.knife", color: .secondary)
            }
        }
        .padding(Dimensions.Space.l)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .shadow(color: .black.opacity(0.04), radius: Dimensions.Elevation.s, x: 0, y: Dimensions.Elevation.xs)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func calculateOverallScore() -> Double {
        let values = viewModel.state.insights.compactMap(\.metricValue)
        guard !values.isEmpty else { return 68 }
        let avg = values.reduce(0, +) / Double(values.count)
        return max(min(avg * 10, 100), 0)
    }

    private func breakdownMetric(title: String, icon: String, color: Color) -> some View {
        VStack(spacing: Dimensions.Space.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(title)
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)
        }
    }

    // MARK: - Recent Reports

    private var recentReports: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text("Recent Reports")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
                .padding(.horizontal, Dimensions.Space.m)

            ForEach(viewModel.state.insights.suffix(5)) { insight in
                insightReportRow(insight)
                    .padding(.horizontal, Dimensions.Space.m)
            }
        }
    }

    private func insightReportRow(_ insight: HealthInsight) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Circle()
                .fill(Color.secondaryFixed.opacity(0.5))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                )

            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                Text(insight.title)
                    .font(Typography.titleSmall)
                    .foregroundColor(.onSurface)
                Text(insight.description)
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                    .lineLimit(2)
            }

            Spacer()

            if let value = insight.metricValue {
                Text(String(format: "%.1f", value))
                    .font(Typography.labelLarge)
                    .foregroundColor(metricColor(value))
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
    }
}
