import SwiftUI

public struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    private let onLogout: () -> Void

    @State private var darkModeEnabled = false
    @State private var selectedUnits = "Metric"

    public init(viewModel: SettingsViewModel, onLogout: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onLogout = onLogout
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Dimensions.Space.l) {
                // Header description
                headerSection

                // Account section
                accountSection

                // Preferences section
                preferencesSection

                // Data & Privacy section
                dataPrivacySection

                // About section
                aboutSection

                // Logout button
                logoutSection

                // Footer
                footerSection
            }
            .padding(.vertical, Dimensions.Space.m)
        }
        .background(Color.background)
        .navigationTitle(localization.string("settings.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .task { await viewModel.load() }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
            Text(localization.string("settings.personal_center"))
                .font(Typography.overline)
                .foregroundColor(.onSurfaceVariant)
                .tracking(1.2)
            Text(localization.string("settings.app_config"))
                .font(Typography.headlineSmall)
                .foregroundColor(.onSurface)
            Text(localization.string("settings.app_config_desc"))
                .font(Typography.bodySmall)
                .foregroundColor(.onSurfaceVariant)
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Account Section

    private var accountSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            sectionLabel(localization.string("settings.account"))

            VStack(spacing: 0) {
                settingsRow(icon: "person.circle", title: localization.string("settings.profile"), showChevron: true)
                Divider().padding(.leading, 56)
                settingsRow(icon: "lock", title: localization.string("settings.change_password"), showChevron: true)
                Divider().padding(.leading, 56)
                settingsRow(icon: "shield.checkered", title: localization.string("settings.privacy"), showChevron: true)
            }
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    // MARK: - Preferences Section

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            sectionLabel(localization.string("settings.preferences"))

            VStack(spacing: 0) {
                // Language
                HStack(spacing: Dimensions.Space.m) {
                    Image(systemName: "globe")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    Text(localization.string("settings.language"))
                        .font(Typography.bodyLarge)
                        .foregroundColor(.onSurface)
                    Spacer()
                    Menu {
                        ForEach(AppLanguage.allCases) { language in
                            Button {
                                localization.currentLanguage = language
                            } label: {
                                HStack {
                                    Text(language.displayName)
                                    if language == localization.currentLanguage {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: Dimensions.Space.xs) {
                            Text(localization.currentLanguage.displayName)
                                .font(Typography.labelMedium)
                                .foregroundColor(.onSurfaceVariant)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.onSurfaceVariant)
                        }
                    }
                }
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.vertical, Dimensions.Space.m)

                Divider().padding(.leading, 56)

                // Notifications toggle
                toggleRow(
                    icon: "bell",
                    title: localization.string("settings.notifications"),
                    isOn: $viewModel.state.notificationsEnabled
                )

                Divider().padding(.leading, 56)

                // Dark mode toggle
                toggleRow(
                    icon: "moon",
                    title: localization.string("settings.dark_mode"),
                    isOn: $darkModeEnabled
                )

                Divider().padding(.leading, 56)

                // Units
                HStack(spacing: Dimensions.Space.m) {
                    Image(systemName: "ruler")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    Text(localization.string("settings.units"))
                        .font(Typography.bodyLarge)
                        .foregroundColor(.onSurface)
                    Spacer()
                    Picker("", selection: $selectedUnits) {
                        Text(localization.string("settings.metric")).tag("Metric")
                        Text(localization.string("settings.imperial")).tag("Imperial")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 160)
                }
                .padding(.horizontal, Dimensions.Space.m)
                .padding(.vertical, Dimensions.Space.m)
            }
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    // MARK: - Data & Privacy Section

    private var dataPrivacySection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            sectionLabel(localization.string("settings.data_privacy"))

            VStack(spacing: Dimensions.Space.m) {
                // Export data button
                Button {
                    // Export placeholder
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16))
                        Text(localization.string("settings.export"))
                            .font(Typography.button)
                        Spacer()
                    }
                    .foregroundColor(.primary)
                    .frame(height: Dimensions.Size.button)
                    .background(Color.tertiaryFixed)
                    .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
                }

                // Delete account link
                Button {
                    // Delete account placeholder
                } label: {
                    Text(localization.string("settings.delete_account"))
                        .font(Typography.labelMedium)
                        .foregroundColor(.error)
                        .underline()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            sectionLabel(localization.string("settings.about"))

            VStack(spacing: 0) {
                settingsRow(icon: "info.circle", title: localization.string("settings.version"), showChevron: false)
                Divider().padding(.leading, 56)
                settingsRow(icon: "doc.text", title: localization.string("settings.terms"), showChevron: true)
                Divider().padding(.leading, 56)
                settingsRow(icon: "hand.raised", title: localization.string("settings.privacy_policy"), showChevron: true)
                Divider().padding(.leading, 56)
                settingsRow(icon: "questionmark.circle", title: localization.string("settings.help"), showChevron: true)
            }
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    // MARK: - Logout

    private var logoutSection: some View {
        VStack(spacing: Dimensions.Space.s) {
            if let error = viewModel.state.error {
                Text(error)
                    .font(Typography.labelSmall)
                    .foregroundColor(.error)
            }

            Button {
                Task {
                    let success = await viewModel.logout()
                    if success { onLogout() }
                }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.state.isLoggingOut {
                        ProgressView()
                            .tint(.onError)
                    } else {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 16))
                        Text(localization.string("settings.logout"))
                            .font(Typography.button)
                    }
                    Spacer()
                }
                .foregroundColor(.surfaceContainerLowest)
                .frame(height: Dimensions.Size.buttonLarge)
                .background(Color.error)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
            }
            .disabled(viewModel.state.isLoggingOut)
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Footer

    private var footerSection: some View {
        Text(localization.string("settings.footer"))
            .font(Typography.overline)
            .foregroundColor(.outlineVariant)
            .tracking(1.5)
            .frame(maxWidth: .infinity)
            .padding(.top, Dimensions.Space.m)
            .padding(.bottom, Dimensions.Space.l)
    }

    // MARK: - Helpers

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(Typography.overline)
            .foregroundColor(.onSurfaceVariant)
            .tracking(1.2)
            .padding(.horizontal, Dimensions.Space.m)
    }

    private func settingsRow(icon: String, title: String, showChevron: Bool) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(title)
                .font(Typography.bodyLarge)
                .foregroundColor(.onSurface)
            Spacer()
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.outlineVariant)
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.m)
    }

    private func toggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(title)
                .font(Typography.bodyLarge)
                .foregroundColor(.onSurface)
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.secondary)
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.m)
    }
}
