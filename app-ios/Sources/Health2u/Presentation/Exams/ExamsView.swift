import SwiftUI

public struct ExamsView: View {
    @StateObject private var viewModel: ExamsViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    @State private var searchText = ""
    @State private var showUploadSheet = false

    private struct FilterOption: Identifiable {
        let id: String          // stable key for ForEach identity
        let backendType: String? // nil means "All"
    }

    private var filterOptions: [FilterOption] {
        [
            FilterOption(id: "all", backendType: nil),
            FilterOption(id: "labs", backendType: "Labs"),
            FilterOption(id: "radiology", backendType: "Imaging"),
            FilterOption(id: "cardiology", backendType: "Cardiology"),
            FilterOption(id: "general", backendType: "General"),
        ]
    }

    private func filterDisplayName(_ option: FilterOption) -> String {
        switch option.id {
        case "all": return localization.string("exams.all_records")
        case "labs": return localization.string("exams.lab_results")
        case "radiology": return localization.string("exams.radiology")
        case "cardiology": return localization.string("exams.cardiology")
        case "general": return localization.string("exams.general")
        default: return option.id
        }
    }

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
        .background(Color.background)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showUploadSheet = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $showUploadSheet) {
            NavigationStack {
                UploadView(viewModel: container.makeUploadViewModel())
            }
        }
        .task { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                // Header
                headerSection

                // Filter chips
                filterChips

                // Search bar
                searchBar

                // Exam cards
                examList
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

    // MARK: - Filter Chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Dimensions.Space.s) {
                ForEach(filterOptions) { option in
                    let isSelected = (option.backendType == nil && viewModel.state.filter == nil)
                        || viewModel.state.filter == option.backendType
                    Button {
                        Task {
                            await viewModel.setFilter(option.backendType)
                        }
                    } label: {
                        Text(filterDisplayName(option))
                            .font(Typography.labelMedium)
                            .foregroundColor(isSelected ? .surfaceContainerLowest : .onSurfaceVariant)
                            .padding(.horizontal, Dimensions.Space.m)
                            .padding(.vertical, Dimensions.Space.s)
                            .background(isSelected ? Color.secondary : Color.surfaceContainerLow)
                            .cornerRadius(Dimensions.CornerRadius.full)
                    }
                }
            }
            .padding(.horizontal, Dimensions.Space.m)
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

    // MARK: - Exam List

    private var examList: some View {
        let filtered = filteredExams
        return LazyVStack(spacing: Dimensions.Space.s) {
            ForEach(filtered) { exam in
                examCard(exam)
                    .padding(.horizontal, Dimensions.Space.m)
            }
        }
    }

    private var filteredExams: [Exam] {
        if searchText.isEmpty { return viewModel.state.exams }
        return viewModel.state.exams.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
                || $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }

    // MARK: - Exam Card

    private func examCard(_ exam: Exam) -> some View {
        Button {
            container.path.append(.examDetail(id: exam.id))
        } label: {
            HStack(alignment: .top, spacing: Dimensions.Space.m) {
                // Type icon circle
                examTypeIcon(exam.type)

                VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                    Text(exam.title)
                        .font(Typography.titleMedium)
                        .foregroundColor(.onSurface)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if let notes = exam.notes, !notes.isEmpty {
                        Text(notes)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                            .lineLimit(1)
                    }

                    Text(Self.formattedDate(exam.date))
                        .font(Typography.labelSmall)
                        .foregroundColor(.outline)

                    // Metric pill
                    HStack(spacing: Dimensions.Space.xs) {
                        Text(exam.type)
                            .font(Typography.labelSmall)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, Dimensions.Space.s)
                            .padding(.vertical, Dimensions.Space.xxs)
                            .background(Color.secondaryFixed.opacity(0.5))
                            .cornerRadius(Dimensions.CornerRadius.s)
                    }
                }

                Spacer(minLength: 0)

                VStack {
                    Spacer()
                    Text(localization.string("exams.view_report"))
                        .font(Typography.labelSmall)
                        .foregroundColor(.secondary)
                    Spacer()
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
