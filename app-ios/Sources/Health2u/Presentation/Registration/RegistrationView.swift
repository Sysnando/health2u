import SwiftUI

public struct RegistrationView: View {
    @StateObject private var viewModel: RegistrationViewModel
    @EnvironmentObject private var container: AppContainer
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showSuccessAlert = false

    public init(viewModel: RegistrationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            // Light background with subtle gradient blobs (matches LoginView)
            Color.background.ignoresSafeArea()

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.secondary.opacity(0.06), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 160
                    )
                )
                .frame(width: 320, height: 320)
                .offset(x: -80, y: -260)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.tertiaryFixed.opacity(0.08), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .offset(x: 120, y: -180)

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)

                    topBranding
                        .padding(.bottom, 40)

                    registrationCard
                        .padding(.horizontal, Dimensions.Space.l)

                    Spacer().frame(height: 40)

                    bottomLinks
                        .padding(.bottom, Dimensions.Space.xl)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.state.didSucceed) { _, newValue in
            if newValue { showSuccessAlert = true }
        }
        .alert(localization.string("registration.success_title"), isPresented: $showSuccessAlert) {
            Button(localization.string("login.sign_in")) { dismiss() }
        } message: {
            Text(localization.string("registration.success_message"))
        }
    }

    // MARK: - Top Branding

    private var topBranding: some View {
        HStack(spacing: Dimensions.Space.s) {
            ZStack {
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                    .fill(Color.primary)
                    .frame(width: 32, height: 32)

                Image(systemName: "cross.fill")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            }
            Text("2YH")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
        }
    }

    // MARK: - Registration Card

    private var registrationCard: some View {
        VStack(spacing: Dimensions.Space.l) {
            // Headline
            VStack(spacing: Dimensions.Space.s) {
                Text(localization.string("registration.create_account"))
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.onSurface)

                Text(localization.string("registration.subtitle"))
                    .font(Typography.bodyLarge)
                    .foregroundColor(.onSurfaceVariant)
            }

            // Fields
            VStack(spacing: Dimensions.Space.m) {
                H2UTextField(
                    title: localization.string("registration.full_name"),
                    text: $viewModel.state.name,
                    placeholder: "Your full name"
                )

                H2UTextField(
                    title: localization.string("registration.email"),
                    text: $viewModel.state.email,
                    placeholder: "you@example.com",
                    keyboardType: .email
                )

                H2UPasswordField(
                    title: localization.string("registration.password"),
                    text: $viewModel.state.password
                )

                H2UPasswordField(
                    title: localization.string("registration.confirm_password"),
                    text: $viewModel.state.confirmPassword
                )
            }

            // Terms checkbox
            Button {
                viewModel.state.agreedToTerms.toggle()
            } label: {
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: viewModel.state.agreedToTerms ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundColor(viewModel.state.agreedToTerms ? .secondary : .outlineVariant)

                    Text(localization.string("registration.agree_terms"))
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            // Error message
            if let err = viewModel.state.error {
                HStack(spacing: Dimensions.Space.xs) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.error)
                    Text(err)
                        .font(Typography.bodySmall)
                        .foregroundColor(.error)
                }
            }

            // Create Account button
            PrimaryButton(title: localization.string("registration.create_account"), isLoading: viewModel.state.isLoading) {
                Task { await viewModel.register() }
            }

            // "Already have an account? Sign In" link
            HStack(spacing: Dimensions.Space.xxs) {
                Text(localization.string("registration.already_have_account"))
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                Button(action: { dismiss() }) {
                    Text(localization.string("login.sign_in"))
                        .font(Typography.labelMedium)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(Dimensions.Space.l)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xxl)
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 4)
    }

    // MARK: - Bottom Links

    private var bottomLinks: some View {
        HStack(spacing: Dimensions.Space.l) {
            Button(action: {}) {
                Text(localization.string("login.terms"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
            Text("|")
                .font(Typography.labelSmall)
                .foregroundColor(.outlineVariant)
            Button(action: {}) {
                Text(localization.string("login.privacy"))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
        }
    }
}
