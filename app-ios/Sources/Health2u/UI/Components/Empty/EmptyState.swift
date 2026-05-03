import SwiftUI

public struct EmptyState: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    public init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.outlineVariant)
            Text(title)
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
            Text(message)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant)
                .multilineTextAlignment(.center)
            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .padding(.top, Dimensions.Space.s)
            }
        }
        .padding(Dimensions.Space.xl)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
