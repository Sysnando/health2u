import SwiftUI

public struct MyHealthView: View {
    @StateObject private var viewModel: MyHealthViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    public init(viewModel: MyHealthViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.years.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.years.isEmpty {
                EmptyState(
                    icon: "cross.case",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else if viewModel.state.years.isEmpty {
                EmptyState(
                    icon: "cross.case",
                    title: localization.string("my_health.title"),
                    message: localization.string("empty.no_data")
                )
            } else {
                content
            }
        }
        .background(Color.background)
        .navigationTitle(localization.string("my_health.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .task(id: container.examsRefreshTrigger) { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                // Scoring note
                HStack(spacing: Dimensions.Space.xs) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.onSurfaceVariant)
                    Text(localization.string("my_health.scoring_coming_soon"))
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                }
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.top, Dimensions.Space.s)

                // Year cards
                ForEach(viewModel.state.years) { year in
                    yearCard(year)
                        .padding(.horizontal, Dimensions.Space.m)
                }
            }
            .padding(.vertical, Dimensions.Space.m)
        }
    }

    // MARK: - Year Card

    private func yearCard(_ year: HealthYear) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Text("\(year.year)")
                .font(Typography.headlineMedium)
                .foregroundColor(.onSurface)

            Spacer()

            Image(systemName: year.color.systemColor)
                .font(.system(size: 22))
                .foregroundColor(colorForHealth(year.color))

            VStack(alignment: .trailing, spacing: Dimensions.Space.xxs) {
                Text("\(year.examCount) \(year.examCount == 1 ? "exam" : "exams")")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurfaceVariant)

                if year.aiAnalyzedCount > 0 {
                    Text(String(format: localization.string("myhealth.ai_analyzed"), year.aiAnalyzedCount))
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                }
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func colorForHealth(_ color: HealthColor) -> Color {
        switch color {
        case .green: return .onTertiaryContainer
        case .yellow: return .tertiaryFixed
        case .red: return .error
        }
    }
}
