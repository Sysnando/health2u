import SwiftUI

public enum H2UKeyboardType: Sendable {
    case `default`, email, numeric, phone
}

public struct H2UTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let keyboardType: H2UKeyboardType
    let error: String?

    public init(
        title: String,
        text: Binding<String>,
        placeholder: String = "",
        keyboardType: H2UKeyboardType = .default,
        error: String? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.error = error
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
            Text(title)
                .font(Typography.inputLabel)
                .foregroundColor(.onSurfaceVariant)
            field
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

    @ViewBuilder private var field: some View {
        #if canImport(UIKit)
        TextField(placeholder, text: $text)
            .keyboardType(uiKeyboardType)
            .autocapitalization(keyboardType == .email ? .none : .sentences)
        #else
        TextField(placeholder, text: $text)
        #endif
    }

    #if canImport(UIKit)
    private var uiKeyboardType: UIKeyboardType {
        switch keyboardType {
        case .default: return .default
        case .email: return .emailAddress
        case .numeric: return .numberPad
        case .phone: return .phonePad
        }
    }
    #endif
}

#if canImport(UIKit)
import UIKit
#endif
