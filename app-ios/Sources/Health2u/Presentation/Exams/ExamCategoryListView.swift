import SwiftUI

public struct ExamCategoryListView: View {
    let categoryId: String
    @StateObject private var viewModel: ExamsViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var searchText = ""
    @State private var showUploadSheet = false

    public init(categoryId: String, viewModel: ExamsViewModel) {
        self.categoryId = categoryId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    private var categoryExams: [Exam] {
        let all = viewModel.state.exams.filter {
            ExamCategory.category(for: $0.type)?.rawValue == categoryId
        }
        if searchText.isEmpty { return all }
        return all.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
                || $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var categoryTitle: String {
        if let cat = ExamCategory(rawValue: categoryId) {
            return localization.string(cat.localizationKey)
        }
        return categoryId
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.exams.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if categoryExams.isEmpty {
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
        .background(Color.background)
        .navigationTitle(categoryTitle)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showUploadSheet = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $showUploadSheet, onDismiss: {
            print("🔄 [ExamCategoryListView \(categoryId)] Upload sheet dismissed — calling notifyExamsChanged()")
            container.notifyExamsChanged()
        }) {
            NavigationStack {
                UploadView(viewModel: container.makeUploadViewModel())
            }
        }
        .task(id: container.examsRefreshTrigger) {
            print("🔄 [ExamCategoryListView \(categoryId)] .task fired — calling viewModel.load()")
            await viewModel.load()
            print("🔄 [ExamCategoryListView \(categoryId)] load returned — exams.count=\(viewModel.state.exams.count) filtered=\(categoryExams.count)")
        }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                // Search bar
                searchBar

                // Exam cards
                LazyVStack(spacing: Dimensions.Space.s) {
                    ForEach(categoryExams) { exam in
                        examCard(exam)
                            .padding(.horizontal, Dimensions.Space.m)
                    }
                }
            }
            .padding(.vertical, Dimensions.Space.m)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: Dimensions.Space.s) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.outline)
                .font(.system(size: 16))
            TextField(localization.string("exams.search"), text: $searchText)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurface)
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.s + 2)
        .background(Color.surfaceContainerLow)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Exam Card

    private func examCard(_ exam: Exam) -> some View {
        Button {
            container.path.append(.examDetail(id: exam.id))
        } label: {
            HStack(alignment: .top, spacing: Dimensions.Space.m) {
                examTypeIcon(exam.type)

                VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                    Text(exam.title)
                        .font(Typography.titleMedium)
                        .foregroundColor(.onSurface)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    // Prefer the AI summary when present; fall back to notes
                    if let summary = exam.analysis?.summary, !summary.isEmpty {
                        Text(summary)
                            .font(Typography.bodySmall.italic())
                            .foregroundColor(.onSurfaceVariant)
                            .lineLimit(1)
                            .multilineTextAlignment(.leading)
                    } else if let notes = exam.notes, !notes.isEmpty {
                        Text(notes)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                            .lineLimit(1)
                    }

                    Text(Self.formattedDate(exam.date))
                        .font(Typography.labelSmall)
                        .foregroundColor(.outline)

                    HStack(spacing: Dimensions.Space.xs) {
                        Text(exam.type)
                            .font(Typography.labelSmall)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, Dimensions.Space.s)
                            .padding(.vertical, Dimensions.Space.xxs)
                            .background(Color.secondaryFixed.opacity(0.5))
                            .cornerRadius(Dimensions.CornerRadius.s)

                        if let analysis = exam.analysis,
                           analysis.status == .completed,
                           let summary = analysis.summary,
                           !summary.isEmpty {
                            aiAnalyzedBadge
                        }
                    }
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing, spacing: Dimensions.Space.xs) {
                    if let analysis = exam.analysis, analysis.status != .completed {
                        statusPill(for: analysis.status)
                    }
                    Text(localization.string("exams.view_report"))
                        .font(Typography.labelSmall)
                        .foregroundColor(.secondary)
                }
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .overlay(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.l)
                    .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var aiAnalyzedBadge: some View {
        Text(localization.string("exam.ai_analyzed_badge"))
            .font(Typography.labelSmall)
            .foregroundColor(.onTertiaryContainer)
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xxs)
            .background(Color.tertiaryFixed.opacity(0.5))
            .cornerRadius(Dimensions.CornerRadius.s)
    }

    @ViewBuilder
    private func statusPill(for status: ExamAnalysis.Status) -> some View {
        switch status {
        case .processing:
            Text(localization.string("exam.processing"))
                .font(Typography.labelSmall)
                .foregroundColor(.onTertiaryContainer)
                .padding(.horizontal, Dimensions.Space.s)
                .padding(.vertical, Dimensions.Space.xxs)
                .background(Color.tertiaryFixed.opacity(0.5))
                .cornerRadius(Dimensions.CornerRadius.s)
        case .failed:
            Text(localization.string("exam.analysis_failed"))
                .font(Typography.labelSmall)
                .foregroundColor(.onErrorContainer)
                .padding(.horizontal, Dimensions.Space.s)
                .padding(.vertical, Dimensions.Space.xxs)
                .background(Color.errorContainer)
                .cornerRadius(Dimensions.CornerRadius.s)
        case .completed:
            EmptyView()
        }
    }

    private func examTypeIcon(_ type: String) -> some View {
        let (iconName, color) = examTypeConfig(type)
        return Circle()
            .fill(color.opacity(0.15))
            .frame(width: 44, height: 44)
            .overlay(
                Image(systemName: iconName)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            )
    }

    private func examTypeConfig(_ type: String) -> (String, Color) {
        switch type.lowercased() {
        case "labs", "lab results":
            return ("drop.fill", .onTertiaryContainer)
        case "radiology", "imaging":
            return ("rays", .secondary)
        case "cardiology":
            return ("heart.fill", .error)
        default:
            return ("doc.text.fill", .surfaceTint)
        }
    }

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
