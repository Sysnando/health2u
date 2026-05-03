import SwiftUI

public struct H2UPasswordField: View {
    let title: String
    @Binding var text: String
    let error: String?
    @State private var isSecure: Bool = true

    public init(title: String, text: Binding<String>, error: String? = nil) {
        self.title = title
        self._text = text
        self.error = error
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
            Text(title)
                .font(Typography.inputLabel)
                .foregroundColor(.onSurfaceVariant)
            HStack(spacing: Dimensions.Space.s) {
                if isSecure {
                    SecureField("", text: $text)
                } else {
                    TextField("", text: $text)
                }
                Button {
                    isSecure.toggle()
                } label: {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundColor(.outline)
                        .frame(width: Dimensions.Size.icon, height: Dimensions.Size.icon)
                }
                .frame(minWidth: Dimensions.Size.touchTarget, minHeight: Dimensions.Size.touchTarget)
            }
            .font(Typography.input)
            .padding(.horizontal, Dimensions.Space.m)
            .frame(height: Dimensions.Size.buttonLarge)
            .background(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                    .stroke(borderColor, lineWidth: error == nil ? 1 : 1.5)
            )
            if let error {
                Text(error)
                    .font(Typography.error)
                    .foregroundColor(.error)
            }
        }
    }

    private var borderColor: Color {
        error == nil ? .outlineVariant : .error
    }
}
