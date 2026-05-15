import SwiftUI

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    public init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.user == nil {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.user == nil {
                EmptyState(
                    icon: "person.crop.circle.badge.exclamationmark",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else {
                content
            }
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
        .task { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Dark gradient header
                profileHeader

                // Info section
                VStack(spacing: Dimensions.Space.l) {
                    infoSection
                    medicalRecordsSection
                    emergencyContactsSection
                    logoutButton
                }
                .padding(.top, Dimensions.Space.l)
                .padding(.bottom, Dimensions.Space.xxl)
            }
        }
        .background(Color.background)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        ZStack {
            LinearGradient(
                colors: [.primary, .primaryContainer],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: Dimensions.Space.m) {
                Spacer()
                    .frame(height: 60)

                HStack {
                    Text("2YH")
                        .font(Typography.labelMedium)
                        .foregroundColor(.surfaceContainerLowest.opacity(0.7))
                    Spacer()
                }
                .padding(.horizontal, Dimensions.Space.m)

                // Avatar
                Circle()
                    .fill(Color.surfaceContainerLowest.opacity(0.2))
                    .frame(width: 96, height: 96)
                    .overlay(
                        Circle()
                            .stroke(Color.surfaceContainerLowest, lineWidth: 3)
                    )
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.surfaceContainerLowest)
                    )

                if let user = viewModel.state.user {
                    Text(user.name)
                        .font(Typography.headlineMedium)
                        .foregroundColor(.surfaceContainerLowest)

                    Text(user.email)
                        .font(Typography.bodyMedium)
                        .foregroundColor(.surfaceContainerLowest.opacity(0.7))
                }

                // Edit profile button
                Button {
                    container.path.append(.editProfile)
                } label: {
                    Text(localization.string("profile.edit"))
                        .font(Typography.button)
                        .foregroundColor(.surfaceContainerLowest)
                        .padding(.horizontal, Dimensions.Space.l)
                        .padding(.vertical, Dimensions.Space.s)
                        .overlay(
                            RoundedRectangle(cornerRadius: Dimensions.CornerRadius.full)
                                .stroke(Color.surfaceContainerLowest, lineWidth: 1.5)
                        )
                }

                Spacer()
                    .frame(height: Dimensions.Space.l)
            }
        }
        .frame(height: 380)
    }

    // MARK: - Info Section

    private var infoSection: some View {
        VStack(spacing: 0) {
            if let user = viewModel.state.user {
                infoRow(
                    icon: "calendar",
                    label: localization.string("profile.date_of_birth"),
                    value: user.dateOfBirth.map(Self.formattedDate) ?? localization.string("profile.not_set")
                )
                Divider().padding(.leading, 56)
                infoRow(
                    icon: "person",
                    label: localization.string("profile.gender"),
                    value: user.gender ?? localization.string("profile.not_set")
                )
                Divider().padding(.leading, 56)
                infoRow(
                    icon: "ruler",
                    label: localization.string("profile.height"),
                    value: user.heightCm.map { "\(String(format: "%.0f", $0)) cm" } ?? localization.string("profile.not_set")
                )
                Divider().padding(.leading, 56)
                infoRow(
                    icon: "scalemass",
                    label: localization.string("profile.weight"),
                    value: user.weightKg.map { "\(String(format: "%.1f", $0)) kg" } ?? localization.string("profile.not_set")
                )
                Divider().padding(.leading, 56)
                infoRow(
                    icon: "drop.fill",
                    label: localization.string("profile.blood_type"),
                    value: user.bloodType ?? localization.string("profile.not_set")
                )
            }
        }
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 18))
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
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.m)
    }

    // MARK: - Medical Records Section

    private var medicalRecordsSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text(localization.string("profile.medical_records"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
                .padding(.horizontal, Dimensions.Space.m)

            let categories = [localization.string("profile.allergies"), localization.string("profile.medications"), localization.string("profile.past_conditions"), localization.string("profile.chronic_conditions"), localization.string("profile.active_asthma")]
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Dimensions.Space.s) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(Typography.labelSmall)
                            .foregroundColor(.onSurfaceVariant)
                            .padding(.horizontal, Dimensions.Space.m)
                            .padding(.vertical, Dimensions.Space.s)
                            .background(Color.surfaceContainerLow)
                            .cornerRadius(Dimensions.CornerRadius.full)
                    }
                }
                .padding(.horizontal, Dimensions.Space.m)
            }
        }
    }

    // MARK: - Emergency Contacts Section

    private var emergencyContactsSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            HStack {
                Text(localization.string("profile.emergency_contacts"))
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurface)
                Spacer()
                Button {
                    container.path.append(.emergencyContacts)
                } label: {
                    Text(localization.string("profile.view_all"))
                        .font(Typography.labelMedium)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, Dimensions.Space.m)

            // Placeholder contact cards
            VStack(spacing: Dimensions.Space.s) {
                emergencyContactRow(name: localization.string("profile.emergency_contact_placeholder"), phone: localization.string("profile.tap_to_manage"))
            }
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    private func emergencyContactRow(name: String, phone: String) -> some View {
        Button {
            container.path.append(.emergencyContacts)
        } label: {
            HStack(spacing: Dimensions.Space.m) {
                Circle()
                    .fill(Color.surfaceContainerLow)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.onSurfaceVariant)
                    )
                VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                    Text(name)
                        .font(Typography.titleSmall)
                        .foregroundColor(.onSurface)
                    Text(phone)
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.outlineVariant)
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Logout Button

    private var logoutButton: some View {
        Button {
            container.path.append(.settings)
        } label: {
            HStack {
                Spacer()
                Image(systemName: "gearshape")
                    .font(.system(size: 16))
                Text(localization.string("settings.title"))
                    .font(Typography.button)
                Spacer()
            }
            .foregroundColor(.onSurface)
            .frame(height: Dimensions.Size.buttonLarge)
            .background(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                    .stroke(Color.outlineVariant, lineWidth: 1.5)
            )
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Formatters

    private static func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
