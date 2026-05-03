import SwiftUI

public struct WelcomeView: View {
    private let onSignIn: () -> Void
    private let onSignUp: () -> Void

    public init(onSignIn: @escaping () -> Void, onSignUp: @escaping () -> Void = {}) {
        self.onSignIn = onSignIn; self.onSignUp = onSignUp
    }

    @State private var progress: CGFloat = 0.0
    @State private var dotOpacity: Double = 0.4

    public var body: some View {
        ZStack {
            // Gradient background: light gray-blue at top fading to white
            LinearGradient(
                colors: [Color.surfaceContainerLow, Color.surfaceContainerLowest],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Centered icon: rounded square with shield+heart
                ZStack {
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                        .fill(Color.secondary)
                        .frame(width: 88, height: 88)
                        .shadow(color: Color.secondary.opacity(0.3), radius: 12, x: 0, y: 6)

                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(.white)
                }

                // Brand name
                Text("2YH")
                    .font(.system(size: 22, weight: .bold))
                    .tracking(6)
                    .foregroundColor(.primary)
                    .padding(.top, Dimensions.Space.l)

                Spacer()

                // "SECURE DATA SYNC ACTIVE" label with animated dots
                HStack(spacing: Dimensions.Space.xs) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 5, height: 5)
                            .opacity(dotOpacity)
                            .animation(
                                .easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(i) * 0.2),
                                value: dotOpacity
                            )
                    }
                    Text("SECURE DATA SYNC ACTIVE")
                        .font(Typography.overline)
                        .tracking(1.5)
                        .foregroundColor(.onSurfaceVariant)
                }
                .padding(.bottom, Dimensions.Space.m)

                // Blue progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.outlineVariant.opacity(0.4))
                            .frame(height: 4)

                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.secondary)
                            .frame(width: geo.size.width * progress, height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, Dimensions.Space.xxl)
                .padding(.bottom, Dimensions.Space.l)

                // Bottom lock icon + encryption text
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.onSurfaceVariant)
                    Text("END-TO-END ENCRYPTED ARCHITECTURE")
                        .font(Typography.caption)
                        .tracking(1)
                        .foregroundColor(.onSurfaceVariant)
                }
                .padding(.bottom, Dimensions.Space.xl)
            }

            // Small red asterisk in bottom-right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("*")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.error)
                        .padding(.trailing, Dimensions.Space.m)
                        .padding(.bottom, Dimensions.Space.m)
                }
            }
        }
        .onAppear {
            dotOpacity = 1.0
            withAnimation(.easeInOut(duration: 2.0)) {
                progress = 1.0
            }
            // Navigate after loading completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                onSignIn()
            }
        }
    }
}
