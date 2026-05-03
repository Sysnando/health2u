import SwiftUI

public struct RegistrationView: View {
    @StateObject private var viewModel: RegistrationViewModel
    @EnvironmentObject private var container: AppContainer
    @Environment(\.dismiss) private var dismiss
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
        .alert("Account Created", isPresented: $showSuccessAlert) {
            Button("Sign In") { dismiss() }
        } message: {
            Text("Account created! Please sign in.")
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
                Text("Create Account")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.onSurface)

                Text("Join to manage your health records")
                    .font(Typography.bodyLarge)
                    .foregroundColor(.onSurfaceVariant)
            }

            // Fields
            VStack(spacing: Dimensions.Space.m) {
                H2UTextField(
                    title: "Full Name",
                    text: $viewModel.state.name,
                    placeholder: "Your full name"
                )

                H2UTextField(
                    title: "Email",
                    text: $viewModel.state.email,
                    placeholder: "you@example.com",
                    keyboardType: .email
                )

                H2UPasswordField(
                    title: "Password",
                    text: $viewModel.state.password
                )

                H2UPasswordField(
                    title: "Confirm Password",
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

                    Text("I agree to the Terms of Service")
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
            PrimaryButton(title: "Create Account", isLoading: viewModel.state.isLoading) {
                Task { await viewModel.register() }
            }

            // "Already have an account? Sign In" link
            HStack(spacing: Dimensions.Space.xxs) {
                Text("Already have an account?")
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                Button(action: { dismiss() }) {
                    Text("Sign In")
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
                Text("Terms of Service")
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
            Text("|")
                .font(Typography.labelSmall)
                .foregroundColor(.outlineVariant)
            Button(action: {}) {
                Text("Privacy Policy")
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
        }
    }
}
