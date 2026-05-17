import SwiftUI

public struct ExamDetailView: View {
    @StateObject private var viewModel: ExamDetailViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: ExamDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                LoadingIndicator(message: localization.string("exam_detail.loading"))
            } else if let error = viewModel.state.error, viewModel.state.exam == nil {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else if let exam = viewModel.state.exam {
                content(exam)
            }
        }
        .background(Color.background)
        .navigationTitle(localization.string("exam_detail.title"))
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

                // AI Summary card
                if let summary = exam.analysis?.summary, !summary.isEmpty {
                    aiSummaryCard(summary)
                }

                // Structured data card (lab results / prescription / imaging / other)
                if let analysis = exam.analysis {
                    structuredDataCard(analysis.extractedData)
                }

                // Re-analyze button (only when analysis failed)
                if exam.analysis?.status == .failed {
                    reanalyzeButton
                        .padding(.horizontal, Dimensions.Space.m)
                }

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

    // MARK: - AI Summary Card

    private func aiSummaryCard(_ summary: String) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            HStack {
                Text(localization.string("exam.ai_summary"))
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurface)
                Spacer()
                Text(localization.string("exam.ai_analyzed_badge"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onTertiaryContainer)
                    .padding(.horizontal, Dimensions.Space.s)
                    .padding(.vertical, Dimensions.Space.xxs)
                    .background(Color.tertiaryFixed.opacity(0.5))
                    .cornerRadius(Dimensions.CornerRadius.s)
            }
            Text(summary)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Structured Data Card

    @ViewBuilder
    private func structuredDataCard(_ data: ExtractedData) -> some View {
        switch data {
        case .labResults(let labResults):
            labResultsCard(labResults)
        case .prescription(let prescription):
            prescriptionCard(prescription)
        case .imagingReport(let report):
            imagingReportCard(report)
        case .other(let content):
            if let content = content, !content.isEmpty {
                otherContentCard(content)
            } else {
                EmptyView()
            }
        case .unknown:
            EmptyView()
        }
    }

    // MARK: - Lab Results

    private func labResultsCard(_ labResults: LabResults) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("exam.lab_results"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            // Subheader: patient / lab / date
            let subheaderParts: [String] = [
                labResults.patientName,
                labResults.labName,
                labResults.testDate
            ].compactMap { $0?.isEmpty == false ? $0 : nil }

            if !subheaderParts.isEmpty {
                Text(subheaderParts.joined(separator: " • "))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }

            if !labResults.results.isEmpty {
                VStack(spacing: Dimensions.Space.s) {
                    ForEach(Array(labResults.results.enumerated()), id: \.offset) { _, result in
                        labResultRow(result)
                    }
                }
                .padding(.top, Dimensions.Space.xs)
            }
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func labResultRow(_ result: LabResult) -> some View {
        HStack(alignment: .top, spacing: Dimensions.Space.s) {
            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                Text(result.testName)
                    .font(Typography.bodyMedium.weight(.semibold))
                    .foregroundColor(.onSurface)

                HStack(spacing: Dimensions.Space.xs) {
                    Text(result.value + (result.unit.map { " \($0)" } ?? ""))
                        .font(Typography.bodyMedium)
                        .foregroundColor(.onSurface)

                    if let range = result.referenceRange, !range.isEmpty {
                        Text("(\(range))")
                            .font(Typography.labelSmall)
                            .foregroundColor(.onSurfaceVariant)
                    }
                }
            }
            Spacer(minLength: 0)
            if let flag = result.flag, !flag.isEmpty {
                flagBadge(flag)
            }
        }
        .padding(.vertical, Dimensions.Space.xxs)
    }

    @ViewBuilder
    private func flagBadge(_ flag: String) -> some View {
        let normalized = flag.lowercased()
        let (label, bg, fg): (String, Color, Color) = {
            switch normalized {
            case "normal":
                return (localization.string("exam.flag_normal"), Color.tertiaryFixed.opacity(0.5), Color.onTertiaryContainer)
            case "high":
                return (localization.string("exam.flag_high"), Color.errorContainer, Color.onErrorContainer)
            case "low":
                return (localization.string("exam.flag_low"), Color.secondaryFixed.opacity(0.6), Color.secondary)
            default:
                return (flag, Color.surfaceContainerLow, Color.onSurfaceVariant)
            }
        }()

        Text(label)
            .font(Typography.labelSmall)
            .foregroundColor(fg)
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xxs)
            .background(bg)
            .cornerRadius(Dimensions.CornerRadius.s)
    }

    // MARK: - Prescription

    private func prescriptionCard(_ prescription: Prescription) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("exam.prescription"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            let subheaderParts: [String] = [prescription.prescriber, prescription.date]
                .compactMap { $0?.isEmpty == false ? $0 : nil }
            if !subheaderParts.isEmpty {
                Text(subheaderParts.joined(separator: " • "))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }

            if !prescription.medications.isEmpty {
                VStack(alignment: .leading, spacing: Dimensions.Space.s) {
                    ForEach(Array(prescription.medications.enumerated()), id: \.offset) { _, med in
                        medicationRow(med)
                    }
                }
                .padding(.top, Dimensions.Space.xs)
            }
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func medicationRow(_ med: Medication) -> some View {
        let detailParts: [String] = [med.dosage, med.frequency, med.duration]
            .compactMap { $0?.isEmpty == false ? $0 : nil }

        return VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
            Text(med.name)
                .font(Typography.bodyMedium.weight(.semibold))
                .foregroundColor(.onSurface)
            if !detailParts.isEmpty {
                Text(detailParts.joined(separator: " • "))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Imaging Report

    private func imagingReportCard(_ report: ImagingReport) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("exam.imaging_report"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            VStack(alignment: .leading, spacing: Dimensions.Space.s) {
                imagingRow(label: localization.string("exam.modality"), value: report.modality)
                imagingRow(label: localization.string("exam.body_part"), value: report.bodyPart)
                imagingRow(label: localization.string("exam.findings"), value: report.findings)
                imagingRow(label: localization.string("exam.impression"), value: report.impression)
            }
            .padding(.top, Dimensions.Space.xs)
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.horizontal, Dimensions.Space.m)
    }

    @ViewBuilder
    private func imagingRow(label: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                Text(label)
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
                Text(value)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurface)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Other content

    private func otherContentCard(_ content: String) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(content)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurface)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Re-analyze Button

    private var reanalyzeButton: some View {
        PrimaryButton(
            title: localization.string("exam.reanalyze"),
            isLoading: viewModel.state.isReanalyzing
        ) {
            Task { await viewModel.reanalyze() }
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
                            Text(localization.string("exam_detail.file_preview"))
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
                            Text(localization.string("exam_detail.no_file"))
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
            Text(localization.string("exam_detail.details_section"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            detailRow(icon: "doc.text", label: localization.string("exam_detail.type_label"), value: exam.type)
            detailRow(icon: "calendar", label: localization.string("exam_detail.date_label"), value: Self.formattedDate(exam.date))
            detailRow(icon: "clock", label: localization.string("exam_detail.created_label"), value: Self.formattedDateTime(exam.createdAt))
            detailRow(icon: "arrow.triangle.2.circlepath", label: localization.string("exam_detail.updated_label"), value: Self.formattedDateTime(exam.updatedAt))
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
            Text(localization.string("exam_detail.notes_section"))
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
                    Text(localization.string("exam_detail.delete_button"))
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
