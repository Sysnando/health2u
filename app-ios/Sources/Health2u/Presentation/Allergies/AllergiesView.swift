import SwiftUI

public struct AllergiesView: View {
    @StateObject private var viewModel: AllergiesViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    public init(viewModel: AllergiesViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.allergies.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.allergies.isEmpty {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else if viewModel.state.allergies.isEmpty {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: localization.string("allergies.title"),
                    message: localization.string("empty.no_data"),
                    actionTitle: localization.string("allergies.add"),
                    action: { viewModel.state.showAddSheet = true }
                )
            } else {
                content
            }
        }
        .background(Color.background)
        .navigationTitle(localization.string("allergies.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { viewModel.state.showAddSheet = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $viewModel.state.showAddSheet) {
            addAllergySheet
        }
        .task { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: Dimensions.Space.s) {
                ForEach(viewModel.state.allergies) { allergy in
                    allergyCard(allergy)
                        .padding(.horizontal, Dimensions.Space.m)
                }
            }
            .padding(.vertical, Dimensions.Space.m)
        }
    }

    // MARK: - Allergy Card

    private func allergyCard(_ allergy: Allergy) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                HStack(spacing: Dimensions.Space.s) {
                    Text(allergy.name)
                        .font(Typography.titleSmall)
                        .foregroundColor(.onSurface)

                    if let severity = allergy.severity, !severity.isEmpty {
                        severityBadge(severity)
                    }
                }

                if let notes = allergy.notes, !notes.isEmpty {
                    Text(notes)
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                        .lineLimit(2)
                }
            }

            Spacer()

            Button {
                Task { await viewModel.delete(id: allergy.id) }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.error)
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    private func severityBadge(_ severity: String) -> some View {
        Text(severity)
            .font(Typography.labelSmall)
            .foregroundColor(severityTextColor(severity))
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xxs)
            .background(severityBackgroundColor(severity))
            .cornerRadius(Dimensions.CornerRadius.full)
    }

    private func severityTextColor(_ severity: String) -> Color {
        switch severity.lowercased() {
        case "low": return .onTertiaryContainer
        case "medium": return .tertiaryFixed
        case "high": return .error
        default: return .onSurfaceVariant
        }
    }

    private func severityBackgroundColor(_ severity: String) -> Color {
        switch severity.lowercased() {
        case "low": return Color.onTertiaryContainer.opacity(0.15)
        case "medium": return Color.tertiaryFixed.opacity(0.2)
        case "high": return Color.error.opacity(0.15)
        default: return Color.surfaceContainerLow
        }
    }

    // MARK: - Add Allergy Sheet

    private var addAllergySheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Dimensions.Space.l) {
                    VStack(spacing: Dimensions.Space.m) {
                        H2UTextField(
                            title: localization.string("allergies.name"),
                            text: $viewModel.state.newName,
                            placeholder: localization.string("allergies.name_placeholder")
                        )

                        // Severity picker
                        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                            Text(localization.string("allergies.severity"))
                                .font(Typography.labelMedium)
                                .foregroundColor(.onSurfaceVariant)

                            HStack(spacing: Dimensions.Space.s) {
                                ForEach(["Low", "Medium", "High"], id: \.self) { level in
                                    let isSelected = viewModel.state.newSeverity == level
                                    Button {
                                        viewModel.state.newSeverity = isSelected ? "" : level
                                    } label: {
                                        Text(level)
                                            .font(Typography.labelMedium)
                                            .foregroundColor(isSelected ? .surfaceContainerLowest : .onSurfaceVariant)
                                            .padding(.horizontal, Dimensions.Space.m)
                                            .padding(.vertical, Dimensions.Space.s)
                                            .background(isSelected ? Color.secondary : Color.surfaceContainerLow)
                                            .cornerRadius(Dimensions.CornerRadius.full)
                                    }
                                }
                            }
                        }

                        // Notes
                        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                            Text(localization.string("allergies.notes"))
                                .font(Typography.labelMedium)
                                .foregroundColor(.onSurfaceVariant)
                            TextEditor(text: $viewModel.state.newNotes)
                                .font(Typography.bodyMedium)
                                .foregroundColor(.onSurface)
                                .frame(minHeight: 80)
                                .padding(Dimensions.Space.s)
                                .background(
                                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                                        .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
                                )
                                .scrollContentBackground(.hidden)
                        }
                    }
                    .padding(Dimensions.Space.m)
                    .background(Color.surfaceContainerLowest)
                    .cornerRadius(Dimensions.CornerRadius.l)
                    .padding(.horizontal, Dimensions.Space.m)

                    PrimaryButton(
                        title: localization.string("common.save"),
                        isLoading: viewModel.state.isSaving
                    ) {
                        Task { await viewModel.add() }
                    }
                    .padding(.horizontal, Dimensions.Space.m)
                }
                .padding(.top, Dimensions.Space.m)
            }
            .background(Color.background)
            .navigationTitle(localization.string("allergies.add"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        viewModel.state.showAddSheet = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.onSurfaceVariant)
                    }
                }
            }
        }
    }
}
