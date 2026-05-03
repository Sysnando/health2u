import SwiftUI

public struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(Typography.button)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: Dimensions.Size.buttonLarge)
                .background(
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                        .stroke(Color.secondary, lineWidth: 1.5)
                )
        }
    }
}
