import SwiftUI
import PhotosUI

public struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem? = nil

    public init(viewModel: EditProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                LoadingIndicator(message: "Loading profile...")
            } else {
                formContent
            }
        }
        .background(Color.background)
        .navigationTitle("Edit Profile")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task { await viewModel.load() }
        .onChange(of: viewModel.state.didSave) { _, didSave in
            if didSave { dismiss() }
        }
    }

    // MARK: - Form Content

    private var formContent: some View {
        ScrollView {
            VStack(spacing: Dimensions.Space.l) {
                // Avatar section
                avatarSection

                // Form fields card
                formFieldsCard

                // Error
                if let error = viewModel.state.error {
                    Text(error)
                        .font(Typography.labelSmall)
                        .foregroundColor(.error)
                        .padding(.horizontal, Dimensions.Space.m)
                }

                // Save button
                PrimaryButton(
                    title: "Save Changes",
                    isLoading: viewModel.state.isSaving
                ) {
                    Task { await viewModel.save() }
                }
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.bottom, Dimensions.Space.l)
            }
            .padding(.top, Dimensions.Space.m)
        }
    }

    // MARK: - Avatar Section

    private var avatarSection: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            VStack(spacing: Dimensions.Space.m) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.surfaceContainerLow)
                        .frame(width: 96, height: 96)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.outlineVariant)
                        )
                        .overlay {
                            if viewModel.state.isUploadingPhoto {
                                Circle()
                                    .fill(Color.black.opacity(0.4))
                                    .frame(width: 96, height: 96)
                                ProgressView()
                                    .tint(.white)
                            }
                        }

                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.surfaceContainerLowest)
                        )
                        .offset(x: 2, y: 2)
                }

                Text("Change Photo")
                    .font(Typography.labelMedium)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .disabled(viewModel.state.isUploadingPhoto)
        .onChange(of: selectedPhoto) { _, newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self) {
                    await viewModel.uploadPhoto(imageData: data)
                }
            }
        }
    }

    // MARK: - Form Fields Card

    private var formFieldsCard: some View {
        VStack(spacing: Dimensions.Space.m) {
            H2UTextField(
                title: "Full Name",
                text: $viewModel.state.name,
                placeholder: "Your full name"
            )

            H2UTextField(
                title: "Email",
                text: $viewModel.state.email,
                placeholder: "Your email address",
                keyboardType: .email
            )

            H2UTextField(
                title: "Phone",
                text: $viewModel.state.phone,
                placeholder: "Your phone number",
                keyboardType: .phone
            )

            // Date of Birth picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Date of Birth")
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                DatePicker(
                    "",
                    selection: Binding(
                        get: { viewModel.state.dateOfBirth ?? Date() },
                        set: { viewModel.state.dateOfBirth = $0 }
                    ),
                    displayedComponents: .date
                )
                .labelsHidden()
                .datePickerStyle(.compact)
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.vertical, Dimensions.Space.s)
                .background(
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                        .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
                )
            }

            // Gender picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Gender")
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                Picker("Gender", selection: $viewModel.state.gender) {
                    Text("Select").tag("")
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                    Text("Other").tag("Other")
                    Text("Prefer not to say").tag("Prefer not to say")
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.vertical, Dimensions.Space.s)
                .background(
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                        .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
                )
            }

            // Height
            H2UTextField(
                title: "Height (cm)",
                text: $viewModel.state.heightCm,
                placeholder: "e.g. 170",
                keyboardType: .numeric
            )

            // Weight
            H2UTextField(
                title: "Weight (kg)",
                text: $viewModel.state.weightKg,
                placeholder: "e.g. 70",
                keyboardType: .numeric
            )

            // Blood Type picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text("Blood Type")
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                Picker("Blood Type", selection: $viewModel.state.bloodType) {
                    Text("Select").tag("")
                    Text("A+").tag("A+")
                    Text("A-").tag("A-")
                    Text("B+").tag("B+")
                    Text("B-").tag("B-")
                    Text("AB+").tag("AB+")
                    Text("AB-").tag("AB-")
                    Text("O+").tag("O+")
                    Text("O-").tag("O-")
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.vertical, Dimensions.Space.s)
                .background(
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                        .stroke(Color.outlineVariant.opacity(0.5), lineWidth: 1)
                )
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }
}
