import SwiftUI

public struct ExamDetailView: View {
    @StateObject private var viewModel: ExamDetailViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: ExamDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                LoadingIndicator(message: "Loading exam...")
            } else if let error = viewModel.state.error, viewModel.state.exam == nil {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: "Error",
                    message: error,
                    actionTitle: "Retry",
                    action: { Task { await viewModel.load() } }
                )
            } else if let exam = viewModel.state.exam {
                content(exam)
            }
        }
        .background(Color.background)
        .navigationTitle("Exam Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task { await viewModel.load() }
        .onChange(of: viewModel.state.didDelete) { _, didDelete in
            if didDelete { dismiss() }
        }
    }

    // MARK: - Content

    private func content(_ exam: Exam) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.l) {
                // Header card
                headerCard(exam)

                // File preview area
                filePreview(exam)

                // Details section
                detailsSection(exam)

                // Notes section
                if let notes = exam.notes, !notes.isEmpty {
                    notesSection(notes)
                }

                // Error
                if let error = viewModel.state.error {
                    Text(error)
                        .font(Typography.labelSmall)
                        .foregroundColor(.error)
                        .padding(.horizontal, Dimensions.Space.m)
                }

                // Delete button
                deleteButton
                    .padding(.horizontal, Dimensions.Space.m)
                    .padding(.bottom, Dimensions.Space.l)
            }
        }
    }

    // MARK: - Header Card

    private func headerCard(_ exam: Exam) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            HStack {
                Text(exam.title)
                    .font(Typography.headlineSmall)
                    .foregroundColor(.onSurface)
                Spacer()
            }

            HStack(spacing: Dimensions.Space.s) {
                // Type badge
                Text(exam.type)
                    .font(Typography.labelSmall)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, Dimensions.Space.s)
                    .padding(.vertical, Dimensions.Space.xxs + 2)
                    .background(Color.secondaryFixed.opacity(0.4))
                    .cornerRadius(Dimensions.CornerRadius.s)

                // Date
                HStack(spacing: Dimensions.Space.xs) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(Self.formattedDate(exam.date))
                        .font(Typography.labelSmall)
                }
                .foregroundColor(.onSurfaceVariant)
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.top, Dimensions.Space.s)
    }

    // MARK: - File Preview

    private func filePreview(_ exam: Exam) -> some View {
        VStack(spacing: Dimensions.Space.s) {
            if exam.fileUrl != nil {
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.l)
                    .fill(Color.surfaceContainerLow)
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: Dimensions.Space.s) {
                            Image(systemName: "doc.richtext")
                                .font(.system(size: 40))
                                .foregroundColor(.outline)
                            Text("File Preview")
                                .font(Typography.labelMedium)
                                .foregroundColor(.onSurfaceVariant)
                        }
                    )
            } else {
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.l)
                    .fill(Color.surfaceContainerLow)
                    .frame(height: 120)
                    .overlay(
                        VStack(spacing: Dimensions.Space.s) {
                            Image(systemName: "doc.badge.plus")
                                .font(.system(size: 32))
                                .foregroundColor(.outline)
                            Text("No file attached")
                                .font(Typography.labelMedium)
                                .foregroundColor(.onSurfaceVariant)
                        }
                    )
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Details Section

    private func detailsSection(_ exam: Exam) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text("Details")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            detailRow(icon: "doc.text", label: "Type", value: exam.type)
            detailRow(icon: "calendar", label: "Date", value: Self.formattedDate(exam.date))
            detailRow(icon: "clock", label: "Created", value: Self.formattedDateTime(exam.createdAt))
            detailRow(icon: "arrow.triangle.2.circlepath", label: "Updated", value: Self.formattedDateTime(exam.updatedAt))
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                Text(label)
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
                Text(value)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurface)
            }
            Spacer()
        }
    }

    // MARK: - Notes Section

    private func notesSection(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text("Notes")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
            Text(notes)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Delete Button

    private var deleteButton: some View {
        Button {
            Task { await viewModel.deleteExam() }
        } label: {
            HStack {
                Spacer()
                if viewModel.state.isDeleting {
                    ProgressView()
                        .tint(.onError)
                } else {
                    Image(systemName: "trash")
                        .font(.system(size: 16))
                    Text("Delete Exam")
                        .font(Typography.button)
                }
                Spacer()
            }
            .foregroundColor(.onError)
            .frame(height: Dimensions.Size.buttonLarge)
            .background(Color.error)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
        }
        .disabled(viewModel.state.isDeleting)
    }

    // MARK: - Formatters

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    private static func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
