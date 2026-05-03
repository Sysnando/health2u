import SwiftUI

public struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var container: AppContainer
    private let onSuccess: () -> Void

    public init(viewModel: LoginViewModel, onSuccess: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onSuccess = onSuccess
    }

    public var body: some View {
        ZStack {
            // Light background with subtle gradient blobs
            Color.background.ignoresSafeArea()

            // Decorative gradient blobs
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

                    // Top: small dark icon + brand name
                    topBranding
                        .padding(.bottom, 40)

                    // Center card
                    loginCard
                        .padding(.horizontal, Dimensions.Space.l)

                    Spacer().frame(height: 40)

                    // Bottom: Terms / Privacy links
                    bottomLinks
                        .padding(.bottom, Dimensions.Space.xl)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: viewModel.state.didSucceed) { _, new in if new { onSuccess() } }
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

    // MARK: - Login Card

    private var loginCard: some View {
        VStack(spacing: Dimensions.Space.l) {
            // Headline
            VStack(spacing: Dimensions.Space.s) {
                Text("Welcome Back")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(.onSurface)

                Text("Sign in to access your health data")
                    .font(Typography.bodyLarge)
                    .foregroundColor(.onSurfaceVariant)
            }

            // Social sign-in buttons
            VStack(spacing: Dimensions.Space.m) {
                // Continue with Google
                Button(action: {}) {
                    HStack(spacing: Dimensions.Space.s) {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.onSurface)
                        Text("Continue with Google")
                            .font(Typography.labelLarge)
                            .foregroundColor(.onSurface)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Dimensions.Size.button)
                    .background(Color.surfaceContainerLowest)
                    .cornerRadius(Dimensions.CornerRadius.l)
                    .overlay(
                        RoundedRectangle(cornerRadius: Dimensions.CornerRadius.l)
                            .stroke(Color.outlineVariant, lineWidth: 1)
                    )
                }

                // Continue with Apple
                Button(action: {}) {
                    HStack(spacing: Dimensions.Space.s) {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        Text("Continue with Apple")
                            .font(Typography.labelLarge)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: Dimensions.Size.button)
                    .background(Color.primary)
                    .cornerRadius(Dimensions.CornerRadius.l)
                }
            }

            // Divider with "SECURED ACCESS"
            HStack(spacing: Dimensions.Space.m) {
                Rectangle()
                    .fill(Color.outlineVariant)
                    .frame(height: 1)
                Text("SECURED ACCESS")
                    .font(Typography.overline)
                    .tracking(1)
                    .foregroundColor(.onSurfaceVariant)
                    .layoutPriority(1)
                Rectangle()
                    .fill(Color.outlineVariant)
                    .frame(height: 1)
            }

            // Email / Password fields
            VStack(spacing: Dimensions.Space.m) {
                H2UTextField(
                    title: "Email",
                    text: $viewModel.state.email,
                    placeholder: "you@example.com",
                    keyboardType: .email,
                    error: nil
                )

                H2UPasswordField(
                    title: "Password",
                    text: $viewModel.state.password,
                    error: nil
                )
            }

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

            // Sign In button
            PrimaryButton(title: "Sign In", isLoading: viewModel.state.isLoading) {
                Task { await viewModel.signIn() }
            }

            // "Don't have an account? Join Hub" link
            HStack(spacing: Dimensions.Space.xxs) {
                Text("Don't have an account?")
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                Button(action: { container.path.append(.registration) }) {
                    Text("Join Hub")
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
