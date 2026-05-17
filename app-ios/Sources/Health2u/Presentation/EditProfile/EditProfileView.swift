import SwiftUI
import PhotosUI

public struct EditProfileView: View {
    @StateObject private var viewModel: EditProfileViewModel
    @EnvironmentObject private var container: AppContainer
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedPhoto: PhotosPickerItem? = nil

    public init(viewModel: EditProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                LoadingIndicator(message: localization.string("common.loading"))
            } else {
                formContent
            }
        }
        .background(Color.background)
        .navigationTitle(localization.string("edit_profile.title"))
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
                    title: localization.string("edit_profile.save_button"),
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

    @ViewBuilder
    private var photoUploadOverlay: some View {
        if viewModel.state.isUploadingPhoto {
            Circle()
                .fill(Color.black.opacity(0.4))
                .frame(width: 96, height: 96)
            ProgressView()
                .tint(.white)
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
                        .overlay(photoUploadOverlay)

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

                Text(localization.string("edit_profile.change_photo"))
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
                title: localization.string("edit_profile.full_name"),
                text: $viewModel.state.name,
                placeholder: "Your full name"
            )

            H2UTextField(
                title: localization.string("edit_profile.email"),
                text: $viewModel.state.email,
                placeholder: "Your email address",
                keyboardType: .email
            )

            H2UTextField(
                title: localization.string("edit_profile.phone"),
                text: $viewModel.state.phone,
                placeholder: "Your phone number",
                keyboardType: .phone
            )

            // Date of Birth picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("edit_profile.date_of_birth"))
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
                Text(localization.string("edit_profile.gender"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                Picker(localization.string("edit_profile.gender"), selection: $viewModel.state.gender) {
                    Text(localization.string("common.select")).tag("")
                    Text(localization.string("edit_profile.gender_male")).tag("Male")
                    Text(localization.string("edit_profile.gender_female")).tag("Female")
                    Text(localization.string("edit_profile.gender_other")).tag("Other")
                    Text(localization.string("edit_profile.gender_prefer_not")).tag("Prefer not to say")
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
                title: localization.string("edit_profile.height_cm"),
                text: $viewModel.state.heightCm,
                placeholder: "e.g. 170",
                keyboardType: .numeric
            )

            // Weight
            H2UTextField(
                title: localization.string("edit_profile.weight_kg"),
                text: $viewModel.state.weightKg,
                placeholder: "e.g. 70",
                keyboardType: .numeric
            )

            // Blood Type picker
            VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                Text(localization.string("edit_profile.blood_type"))
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)

                Picker(localization.string("edit_profile.blood_type"), selection: $viewModel.state.bloodType) {
                    Text(localization.string("common.select")).tag("")
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

            // Diabetes Toggle
            Toggle(isOn: $viewModel.state.hasDiabetes) {
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    Text(localization.string("edit_profile.diabetes"))
                        .font(Typography.bodyMedium)
                        .foregroundColor(.onSurface)
                }
            }
            .tint(.secondary)

            // Allergies Toggle
            Toggle(isOn: $viewModel.state.hasAllergies) {
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                    Text(localization.string("edit_profile.allergies"))
                        .font(Typography.bodyMedium)
                        .foregroundColor(.onSurface)
                }
            }
            .tint(.secondary)

            if viewModel.state.hasAllergies {
                Button {
                    dismiss()
                    // Navigate to allergies after dismissal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        container.path.append(.allergies)
                    }
                } label: {
                    HStack(spacing: Dimensions.Space.s) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 14))
                        Text(localization.string("edit_profile.manage_allergies"))
                            .font(Typography.labelMedium)
                    }
                    .foregroundColor(.secondary)
                    .padding(.horizontal, Dimensions.Space.m)
                    .padding(.vertical, Dimensions.Space.s)
                    .background(Color.secondaryFixed.opacity(0.3))
                    .cornerRadius(Dimensions.CornerRadius.full)
                }
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }
}
