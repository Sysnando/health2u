import SwiftUI

public struct LoadingIndicator: View {
    let message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: Dimensions.Space.m) {
            ProgressView()
                .tint(.secondary)
            if let message {
                Text(message)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurfaceVariant)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
