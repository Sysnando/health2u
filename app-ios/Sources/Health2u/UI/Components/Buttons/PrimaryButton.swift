import SwiftUI

public struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    public init(title: String, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(Typography.button)
                    .foregroundColor(.onPrimary)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.onPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Dimensions.Size.buttonLarge)
            .background(Color.primary)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
        }
        .disabled(isLoading)
    }
}
