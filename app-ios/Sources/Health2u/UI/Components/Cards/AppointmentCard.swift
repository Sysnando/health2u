import SwiftUI

public struct AppointmentCard: View {
    let title: String
    let doctorName: String?
    let dateTime: Date
    let status: String
    let onTap: () -> Void

    public init(
        title: String,
        doctorName: String?,
        dateTime: Date,
        status: String,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.doctorName = doctorName
        self.dateTime = dateTime
        self.status = status
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: Dimensions.Space.m) {
                // Doctor avatar circle
                ZStack {
                    Circle()
                        .fill(Color.secondaryFixed)
                        .frame(width: Dimensions.Size.avatarMedium, height: Dimensions.Size.avatarMedium)
                    Text(avatarInitials)
                        .font(Typography.titleMedium)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
                    // Name and status row
                    HStack {
                        Text(doctorName ?? title)
                            .font(Typography.titleMedium)
                            .foregroundColor(.onSurface)
                        Spacer()
                        statusBadge
                    }

                    // Specialty / title (show title when doctorName is present)
                    if doctorName != nil {
                        Text(title)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                    }

                    // Date/time row
                    HStack(spacing: Dimensions.Space.xs) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.outline)
                        Text(formattedDate)
                            .font(Typography.labelSmall)
                            .foregroundColor(.outline)
                        Text(formattedTime)
                            .font(Typography.labelSmall)
                            .foregroundColor(.outline)
                    }

                    // View Details button
                    HStack {
                        Spacer()
                        Text("View Details")
                            .font(Typography.labelMedium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(Dimensions.Space.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.surfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
            .overlay(
                RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                    .stroke(Color.outlineVariant.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Status Badge

    private var statusBadge: some View {
        Text(statusLabel)
            .font(Typography.labelSmall)
            .foregroundColor(statusForeground)
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xxs)
            .background(statusBackground)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.full))
    }

    private var statusLabel: String {
        switch status.uppercased() {
        case "UPCOMING": return "Confirmed"
        case "COMPLETED": return "Completed"
        case "CANCELLED": return "Cancelled"
        default: return status.capitalized
        }
    }

    private var statusForeground: Color {
        switch status.uppercased() {
        case "UPCOMING": return .successGreen
        case "COMPLETED": return .onSurfaceVariant
        case "CANCELLED": return .error
        default: return .outline
        }
    }

    private var statusBackground: Color {
        switch status.uppercased() {
        case "UPCOMING": return .successGreen.opacity(0.12)
        case "COMPLETED": return .surfaceContainerHigh
        case "CANCELLED": return .error.opacity(0.12)
        default: return .surfaceContainerHigh
        }
    }

    // MARK: - Helpers

    private var avatarInitials: String {
        let name = doctorName ?? title
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1) + parts[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: dateTime)
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}
