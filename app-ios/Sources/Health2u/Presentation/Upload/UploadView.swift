import SwiftUI
import UniformTypeIdentifiers
#if canImport(UIKit)
import UIKit
#endif

public struct UploadView: View {
    @StateObject private var viewModel: UploadViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDocumentPicker = false
    #if canImport(UIKit)
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    #endif

    private let typeOptions = ["Labs", "Imaging", "Cardiology", "General"]

    public init(viewModel: UploadViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                    title: "Upload Exam",
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
        .navigationTitle("Upload Exam")
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

                Text("Photo captured")
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)

                Button {
                    capturedImage = nil
                    viewModel.state.imageData = nil
                } label: {
                    Text("Remove")
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
                Text("Remove")
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
                Text("Choose File")
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
            Text("Add your exam")
                .font(Typography.titleSmall)
                .foregroundColor(.onSurface)
            Text("PDF, JPG, PNG up to 10MB")
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)

            HStack(spacing: Dimensions.Space.m) {
                Button {
                    showCamera = true
                } label: {
                    VStack(spacing: Dimensions.Space.xs) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 24))
                        Text("Take Photo")
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
            // Type selector
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Type")
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Dimensions.Space.s) {
                        ForEach(typeOptions, id: \.self) { option in
                            let isSelected = viewModel.state.type == option
                            Button {
                                viewModel.state.type = option
                            } label: {
                                HStack(spacing: Dimensions.Space.xs) {
                                    Image(systemName: typeIcon(option))
                                        .font(.system(size: 14))
                                    Text(option)
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

            // Title (optional)
            H2UTextField(
                title: "Title (Optional)",
                text: $viewModel.state.title,
                placeholder: "Optional — AI will name this"
            )

            // Date picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Exam Date")
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
                Text("Notes")
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

    // MARK: - Helpers

    private func typeIcon(_ type: String) -> String {
        switch type {
        case "Labs": return "drop.fill"
        case "Imaging": return "rays"
        case "Cardiology": return "heart.fill"
        default: return "doc.text.fill"
        }
    }
}
