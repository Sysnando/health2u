import SwiftUI

public struct AppointmentDetailView: View {
    @StateObject private var viewModel: AppointmentDetailViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: AppointmentDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading {
                LoadingIndicator(message: localization.string("appointment_detail.loading"))
            } else if let error = viewModel.state.error, viewModel.state.appointment == nil {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else if let appointment = viewModel.state.appointment {
                content(appointment)
            }
        }
        .background(Color.background)
        .navigationTitle(localization.string("appointment_detail.title"))
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .task { await viewModel.load() }
        .onChange(of: viewModel.state.didDelete) { _, didDelete in
            if didDelete { dismiss() }
        }
    }

    // MARK: - Content

    private func content(_ appointment: Appointment) -> some View {
        ScrollView {
            VStack(spacing: Dimensions.Space.l) {
                // Doctor header card
                doctorHeader(appointment)

                // Details card
                detailsCard(appointment)

                // Description
                if let description = appointment.description, !description.isEmpty {
                    descriptionCard(description)
                }

                // Error
                if let error = viewModel.state.error {
                    Text(error)
                        .font(Typography.labelSmall)
                        .foregroundColor(.error)
                        .padding(.horizontal, Dimensions.Space.m)
                }

                // Cancel button
                cancelButton
                    .padding(.horizontal, Dimensions.Space.m)
                    .padding(.bottom, Dimensions.Space.l)
            }
        }
    }

    // MARK: - Doctor Header

    private func doctorHeader(_ appointment: Appointment) -> some View {
        VStack(spacing: Dimensions.Space.m) {
            // Avatar
            Circle()
                .fill(Color.primaryContainer)
                .frame(width: 72, height: 72)
                .overlay(
                    Text(avatarInitials(appointment.doctorName))
                        .font(Typography.headlineSmall)
                        .foregroundColor(.surfaceContainerLowest)
                )

            VStack(spacing: Dimensions.Space.xs) {
                Text(appointment.doctorName ?? localization.string("appointment_detail.doctor_label"))
                    .font(Typography.headlineSmall)
                    .foregroundColor(.onSurface)

                Text(appointment.title)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurfaceVariant)
            }

            statusBadge(appointment.status)
        }
        .frame(maxWidth: .infinity)
        .padding(Dimensions.Space.l)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.top, Dimensions.Space.s)
    }

    private func statusBadge(_ status: AppointmentStatus) -> some View {
        let (text, color) = statusConfig(status)
        return HStack(spacing: Dimensions.Space.xs) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(text)
                .font(Typography.labelMedium)
                .foregroundColor(color)
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.vertical, Dimensions.Space.s)
        .background(color.opacity(0.1))
        .cornerRadius(Dimensions.CornerRadius.full)
    }

    private func statusConfig(_ status: AppointmentStatus) -> (String, Color) {
        switch status {
        case .upcoming: return (localization.string("appointments.confirmed"), .onTertiaryContainer)
        case .completed: return (localization.string("appointments.completed"), .secondary)
        case .cancelled: return (localization.string("appointments.cancelled"), .error)
        }
    }

    // MARK: - Details Card

    private func detailsCard(_ appointment: Appointment) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text(localization.string("appointment_detail.title"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)

            detailRow(
                icon: "calendar",
                label: localization.string("appointment_detail.date_time_label").uppercased(),
                value: Self.formattedDateTime(appointment.dateTime)
            )

            if let location = appointment.location, !location.isEmpty {
                Divider()
                    .background(Color.outlineVariant)
                detailRow(
                    icon: "mappin.and.ellipse",
                    label: localization.string("appointment_detail.location_label").uppercased(),
                    value: location
                )
            }

            if let reminderMinutes = appointment.reminderMinutes {
                Divider()
                    .background(Color.outlineVariant)
                detailRow(
                    icon: "bell",
                    label: localization.string("appointment_detail.reminder_label").uppercased(),
                    value: "\(reminderMinutes) \(localization.string("appointment_detail.minutes_before"))"
                )
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                Text(label)
                    .font(Typography.overline)
                    .foregroundColor(.onSurfaceVariant)
                    .tracking(0.8)
                Text(value)
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurface)
            }
            Spacer()
        }
    }

    // MARK: - Description Card

    private func descriptionCard(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("appointment_detail.description_label"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
            Text(description)
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(Dimensions.Space.m)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Cancel Button

    private var cancelButton: some View {
        Button {
            Task { await viewModel.deleteAppointment() }
        } label: {
            HStack {
                Spacer()
                if viewModel.state.isDeleting {
                    ProgressView()
                        .tint(.onError)
                } else {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 16))
                    Text(localization.string("appointment_detail.cancel_button"))
                        .font(Typography.button)
                }
                Spacer()
            }
            .foregroundColor(.onError)
            .frame(height: Dimensions.Size.buttonLarge)
            .background(Color.error)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
        }
        .disabled(viewModel.state.isDeleting)
    }

    // MARK: - Helpers

    private func avatarInitials(_ name: String?) -> String {
        guard let name = name else { return "?" }
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }

    private static func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy 'at' hh:mm a"
        return formatter.string(from: date)
    }
}
