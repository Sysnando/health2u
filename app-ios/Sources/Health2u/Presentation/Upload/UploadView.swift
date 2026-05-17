import SwiftUI
import UniformTypeIdentifiers
#if canImport(UIKit)
import UIKit
#endif

public struct UploadView: View {
    @StateObject private var viewModel: UploadViewModel
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showDocumentPicker = false
    #if canImport(UIKit)
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    #endif

    public init(viewModel: UploadViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    private var subcategories: [String] {
        if let cat = ExamCategory(rawValue: viewModel.state.category) {
            return cat.subcategories
        }
        return []
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: Dimensions.Space.l) {
                // Upload area
                uploadArea

                // Form fields
                formFields

                // Error
                if let error = viewModel.state.error {
                    Text(error)
                        .font(Typography.labelSmall)
                        .foregroundColor(.error)
                        .padding(.horizontal, Dimensions.Space.m)
                }

                // Upload button
                PrimaryButton(
                    title: localization.string("upload.upload_button"),
                    isLoading: viewModel.state.isUploading
                ) {
                    Task { await viewModel.upload() }
                }
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.bottom, Dimensions.Space.l)
            }
            .padding(.top, Dimensions.Space.m)
        }
        .background(Color.background)
        .overlay(alignment: .bottom) {
            if viewModel.state.skippedReason != nil {
                notAnExamToast
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, Dimensions.Space.l)
                    .padding(.horizontal, Dimensions.Space.m)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.state.skippedReason)
        .onChange(of: viewModel.state.skippedReason) { _, newValue in
            guard newValue != nil else { return }
            Task {
                try? await Task.sleep(for: .seconds(3))
                await MainActor.run {
                    viewModel.state.skippedReason = nil
                }
            }
        }
        .navigationTitle(localization.string("upload.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.onSurfaceVariant)
                }
            }
        }
        .onChange(of: viewModel.state.didSucceed) { _, didSucceed in
            if didSucceed { dismiss() }
        }
        .fileImporter(
            isPresented: $showDocumentPicker,
            allowedContentTypes: [.pdf, .png, .jpeg],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let url = urls.first else { return }
                let accessing = url.startAccessingSecurityScopedResource()
                defer { if accessing { url.stopAccessingSecurityScopedResource() } }
                if let data = try? Data(contentsOf: url) {
                    viewModel.state.fileData = data
                    viewModel.state.filename = url.lastPathComponent
                    viewModel.state.imageData = nil
                    #if canImport(UIKit)
                    capturedImage = nil
                    #endif
                }
            case .failure:
                break
            }
        }
    }

    // MARK: - Upload Area

    private var uploadArea: some View {
        uploadAreaContent
            .frame(maxWidth: .infinity)
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLow)
            .cornerRadius(Dimensions.CornerRadius.l)
            .overlay(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.l)
                    .stroke(
                        Color.outlineVariant,
                        style: StrokeStyle(lineWidth: 1.5, dash: [8, 4])
                    )
            )
            .padding(.horizontal, Dimensions.Space.m)
            #if canImport(UIKit)
            .fullScreenCover(isPresented: $showCamera) {
                CameraPickerView(image: $capturedImage)
                    .ignoresSafeArea()
            }
            .onChange(of: capturedImage) { _, newImage in
                if let newImage {
                    viewModel.state.imageData = newImage.jpegData(compressionQuality: 0.85)
                    viewModel.state.filename = nil
                }
            }
            #endif
    }

    @ViewBuilder
    private var uploadAreaContent: some View {
        #if canImport(UIKit)
        VStack(spacing: Dimensions.Space.m) {
            if let image = capturedImage {
                // Camera image preview
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 160)
                    .cornerRadius(Dimensions.CornerRadius.m)

                Text(localization.string("upload.photo_captured"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)

                Button {
                    capturedImage = nil
                    viewModel.state.imageData = nil
                } label: {
                    Text(localization.string("common.remove"))
                        .font(Typography.labelSmall)
                        .foregroundColor(.error)
                }
            } else if let filename = viewModel.state.filename {
                fileSelectedView(filename: filename)
            } else {
                emptyUploadView
            }
        }
        #else
        VStack(spacing: Dimensions.Space.m) {
            if let filename = viewModel.state.filename {
                fileSelectedView(filename: filename)
            } else {
                chooseFileButton
            }
        }
        #endif
    }

    private func fileSelectedView(filename: String) -> some View {
        VStack(spacing: Dimensions.Space.m) {
            Image(systemName: "doc.fill")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            Text(filename)
                .font(Typography.titleSmall)
                .foregroundColor(.onSurface)
            Button {
                viewModel.state.filename = nil
                viewModel.state.fileData = nil
            } label: {
                Text(localization.string("common.remove"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.error)
            }
        }
    }

    private var chooseFileButton: some View {
        Button {
            showDocumentPicker = true
        } label: {
            VStack(spacing: Dimensions.Space.xs) {
                Image(systemName: "doc.fill")
                    .font(.system(size: 24))
                Text(localization.string("upload.choose_file"))
                    .font(Typography.labelMedium)
            }
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Dimensions.Space.m)
            .background(Color.surfaceContainerLow)
            .cornerRadius(Dimensions.CornerRadius.m)
            .overlay(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                    .stroke(Color.outlineVariant, lineWidth: 1)
            )
        }
    }

    #if canImport(UIKit)
    private var emptyUploadView: some View {
        VStack(spacing: Dimensions.Space.m) {
            Text(localization.string("upload.add_exam_title"))
                .font(Typography.titleSmall)
                .foregroundColor(.onSurface)
            Text(localization.string("upload.file_types_message"))
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)

            HStack(spacing: Dimensions.Space.m) {
                Button {
                    showCamera = true
                } label: {
                    VStack(spacing: Dimensions.Space.xs) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                        Text(localization.string("upload.take_photo"))
                            .font(Typography.labelMedium)
                    }
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Dimensions.Space.m)
                    .background(Color.surfaceContainerLow)
                    .cornerRadius(Dimensions.CornerRadius.m)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                            .stroke(Color.outlineVariant, lineWidth: 1)
                    )
                }

                chooseFileButton
            }
        }
    }
    #endif

    // MARK: - Form Fields

    private var formFields: some View {
        VStack(spacing: Dimensions.Space.m) {
            // Category selector (level 1)
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("upload.category_label"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Dimensions.Space.s) {
                        ForEach(ExamCategory.allCases, id: \.self) { category in
                            let isSelected = viewModel.state.category == category.rawValue
                            Button {
                                viewModel.state.category = category.rawValue
                                // Reset type to first subcategory
                                if let first = category.subcategories.first {
                                    viewModel.state.type = first
                                }
                            } label: {
                                HStack(spacing: Dimensions.Space.xs) {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 14))
                                    Text(localization.string(category.localizationKey))
                                        .font(Typography.labelMedium)
                                }
                                .foregroundColor(isSelected ? .surfaceContainerLowest : .onSurfaceVariant)
                                .padding(.horizontal, Dimensions.Space.m)
                                .padding(.vertical, Dimensions.Space.s)
                                .background(isSelected ? Color.secondary : Color.surfaceContainerLow)
                                .cornerRadius(Dimensions.CornerRadius.full)
                            }
                        }
                    }
                }
            }

            // Subcategory selector (level 2) - only visible when category is selected
            if !subcategories.isEmpty {
                VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                    Text(localization.string("upload.type_label"))
                        .font(Typography.labelMedium)
                        .foregroundColor(.onSurfaceVariant)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Dimensions.Space.s) {
                            ForEach(subcategories, id: \.self) { sub in
                                let isSelected = viewModel.state.type == sub
                                Button {
                                    viewModel.state.type = sub
                                } label: {
                                    Text(sub)
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
                }
            }

            // Title (optional)
            H2UTextField(
                title: localization.string("upload.title_label"),
                text: $viewModel.state.title,
                placeholder: localization.string("upload.title_placeholder")
            )

            // Date picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("upload.exam_date_label"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)
                DatePicker("", selection: $viewModel.state.date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .padding(.horizontal, Dimensions.Space.m)
                    .padding(.vertical, Dimensions.Space.s)
                    .background(
                        RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                            .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
                    )
            }

            // Notes
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("upload.notes_label"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)
                TextEditor(text: $viewModel.state.notes)
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
    }

    // MARK: - Not-an-exam Toast

    private var notAnExamToast: some View {
        let reason = viewModel.state.skippedReason ?? ""
        return HStack(alignment: .top, spacing: Dimensions.Space.s) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundColor(.yellow)
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("upload.not_an_exam"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.surfaceContainerLowest)
                if !reason.isEmpty {
                    Text(String(format: localization.string("upload.not_an_exam_reason"), reason))
                        .font(Typography.labelSmall)
                        .foregroundColor(.surfaceContainerLowest.opacity(0.85))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Dimensions.Space.l)
        .padding(.vertical, Dimensions.Space.m)
        .background(Color.onSurface.opacity(0.85))
        .cornerRadius(Dimensions.CornerRadius.l)
    }
}
