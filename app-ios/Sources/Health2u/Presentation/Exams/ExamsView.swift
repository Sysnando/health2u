import SwiftUI

public struct ExamsView: View {
    @StateObject private var viewModel: ExamsViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    @State private var showUploadSheet = false

    public init(viewModel: ExamsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.exams.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.exams.isEmpty {
                EmptyState(
                    icon: "doc.text",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else if viewModel.state.exams.isEmpty {
                EmptyState(
                    icon: "doc.text",
                    title: localization.string("empty.no_exams"),
                    message: localization.string("empty.no_data"),
                    actionTitle: localization.string("upload.title"),
                    action: { showUploadSheet = true }
                )
            } else {
                content
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.ignoresSafeArea())
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: Dimensions.Space.s) {
                    Button { showUploadSheet = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    NavigationLink(value: Route.profile) {
                        Circle()
                            .fill(Color.secondaryContainer)
                            .frame(width: 34, height: 34)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .sheet(isPresented: $showUploadSheet, onDismiss: {
            print("🔄 [ExamsView] Upload sheet dismissed — calling notifyExamsChanged()")
            container.notifyExamsChanged()
        }) {
            NavigationStack {
                UploadView(viewModel: container.makeUploadViewModel())
            }
        }
        .task(id: container.examsRefreshTrigger) {
            print("🔄 [ExamsView] .task fired (trigger=\(container.examsRefreshTrigger)) — calling viewModel.load()")
            await viewModel.load()
            print("🔄 [ExamsView] viewModel.load() returned — exams.count=\(viewModel.state.exams.count)")
        }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                // Header
                headerSection

                // Category cards grid
                categoryGrid
            }
            .padding(.vertical, Dimensions.Space.m)
        }
        .background(Color.background)
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("exams.clinical_records").uppercased())
                    .font(Typography.overline)
                    .foregroundColor(.onSurfaceVariant)
                    .tracking(1.2)
                Text(localization.string("exams.title"))
                    .font(Typography.headlineLarge)
                    .foregroundColor(.primary)
            }
            Spacer()
            HStack(spacing: Dimensions.Space.xs) {
                Circle()
                    .fill(Color.onTertiaryContainer)
                    .frame(width: 8, height: 8)
                Text(localization.string("exams.live"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onTertiaryContainer)
            }
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xs)
            .background(Color.tertiaryFixed.opacity(0.2))
            .cornerRadius(Dimensions.CornerRadius.full)
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Category Grid

    private var categoryGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: Dimensions.Space.m),
            GridItem(.flexible(), spacing: Dimensions.Space.m)
        ], spacing: Dimensions.Space.m) {
            ForEach(ExamCategory.allCases, id: \.self) { category in
                categoryCard(category)
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func categoryCard(_ category: ExamCategory) -> some View {
        Button {
            container.path.append(.examCategory(category: category.rawValue))
        } label: {
            VStack(alignment: .leading, spacing: Dimensions.Space.s) {
                HStack {
                    Image(systemName: category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.secondary)
                    Spacer()
                    let count = viewModel.state.examCountsByCategory[category.rawValue] ?? 0
                    if count > 0 {
                        Text("\(count)")
                            .font(Typography.labelMedium)
                            .foregroundColor(.surfaceContainerLowest)
                            .frame(width: 26, height: 26)
                            .background(Color.secondary)
                            .cornerRadius(Dimensions.CornerRadius.full)
                    }
                }

                Text(localization.string(category.localizationKey))
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurface)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Text(localization.string(category.descriptionKey))
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(Dimensions.Space.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.xl)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}
