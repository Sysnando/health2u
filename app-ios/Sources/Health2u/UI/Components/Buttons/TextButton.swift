import SwiftUI

public struct TextButton: View {
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
                .frame(minHeight: Dimensions.Size.touchTarget)
        }
    }
}
