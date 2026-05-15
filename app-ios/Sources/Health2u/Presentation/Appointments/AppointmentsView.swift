import SwiftUI

public struct AppointmentsView: View {
    @StateObject private var viewModel: AppointmentsViewModel
    @ObservedObject private var localization = LocalizationManager.shared
    @EnvironmentObject private var container: AppContainer

    @State private var selectedTab: AppointmentTab = .upcoming

    private enum AppointmentTab: CaseIterable {
        case upcoming
        case past
    }

    public init(viewModel: AppointmentsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if viewModel.state.isLoading && viewModel.state.appointments.isEmpty {
                    LoadingIndicator(message: localization.string("appointments.loading"))
                } else if let error = viewModel.state.error, viewModel.state.appointments.isEmpty {
                    EmptyState(
                        icon: "calendar",
                        title: localization.string("appointments.error_title"),
                        message: error,
                        actionTitle: localization.string("common.retry"),
                        action: { Task { await viewModel.load() } }
                    )
                } else if viewModel.state.appointments.isEmpty {
                    EmptyState(
                        icon: "calendar",
                        title: localization.string("appointments.no_appointments_title"),
                        message: localization.string("appointments.no_upcoming_message")
                    )
                } else {
                    content
                }
            }

            // FAB
            fabButton
        }
        .background(Color.background)
        .navigationTitle(localization.string("appointments.title"))
        .task { await viewModel.load() }
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 0) {
            // Tab bar
            tabBar

            // Appointment list
            ScrollView {
                LazyVStack(spacing: Dimensions.Space.m) {
                    ForEach(filteredAppointments) { appointment in
                        appointmentCard(appointment)
                    }

                    if filteredAppointments.isEmpty {
                        VStack(spacing: Dimensions.Space.m) {
                            Image(systemName: selectedTab == .upcoming ? "calendar.badge.clock" : "calendar.badge.checkmark")
                                .font(.system(size: 40))
                                .foregroundColor(.outlineVariant)
                            Text(selectedTab == .upcoming ? localization.string("appointments.no_upcoming") : localization.string("appointments.no_past"))
                                .font(Typography.bodyMedium)
                                .foregroundColor(.onSurfaceVariant)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, Dimensions.Space.xxl)
                    }
                }
                .padding(Dimensions.Space.m)
            }
        }
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppointmentTab.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: Dimensions.Space.s) {
                        Text(tabTitle(for: tab))
                            .font(Typography.labelLarge)
                            .foregroundColor(selectedTab == tab ? .secondary : .onSurfaceVariant)
                        Rectangle()
                            .fill(selectedTab == tab ? Color.secondary : Color.clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
    }

    private func tabTitle(for tab: AppointmentTab) -> String {
        switch tab {
        case .upcoming: return localization.string("appointments.upcoming")
        case .past: return localization.string("appointments.past")
        }
    }

    private var filteredAppointments: [Appointment] {
        viewModel.state.appointments.filter { appointment in
            switch selectedTab {
            case .upcoming:
                return appointment.status == .upcoming
            case .past:
                return appointment.status == .completed || appointment.status == .cancelled
            }
        }
    }

    // MARK: - Appointment Card

    private func appointmentCard(_ appointment: Appointment) -> some View {
        Button {
            container.path.append(.appointmentDetail(id: appointment.id))
        } label: {
            VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                // Doctor info row
                HStack(spacing: Dimensions.Space.m) {
                    // Avatar circle
                    Circle()
                        .fill(Color.primaryContainer)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text(avatarInitials(appointment.doctorName))
                                .font(Typography.titleMedium)
                                .foregroundColor(.surfaceContainerLowest)
                        )

                    VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                        HStack {
                            Text(appointment.doctorName ?? appointment.title)
                                .font(Typography.titleMedium)
                                .foregroundColor(.onSurface)
                            Spacer()
                            statusBadge(appointment.status)
                        }
                        Text(appointment.title)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                    }
                }

                // Date & time row
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.onSurfaceVariant)
                    Text(Self.formattedDateTime(appointment.dateTime))
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                }

                // Location row
                if let location = appointment.location, !location.isEmpty {
                    HStack(spacing: Dimensions.Space.s) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 14))
                            .foregroundColor(.onSurfaceVariant)
                        Text(location)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                    }
                }

                // View details button
                HStack {
                    Spacer()
                    Text(localization.string("appointments.view_details"))
                        .font(Typography.button)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, Dimensions.Space.m)
                        .padding(.vertical, Dimensions.Space.s)
                        .overlay(
                            RoundedRectangle(cornerRadius: Dimensions.CornerRadius.full)
                                .stroke(Color.secondary, lineWidth: 1)
                        )
                }
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .shadow(color: .black.opacity(0.06), radius: Dimensions.Elevation.m, x: 0, y: Dimensions.Elevation.xs)
        }
        .buttonStyle(.plain)
    }

    private func statusBadge(_ status: AppointmentStatus) -> some View {
        let (text, color) = statusConfig(status)
        return Text(text)
            .font(Typography.labelSmall)
            .foregroundColor(color)
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xxs)
            .background(color.opacity(0.12))
            .cornerRadius(Dimensions.CornerRadius.s)
    }

    private func statusConfig(_ status: AppointmentStatus) -> (String, Color) {
        switch status {
        case .upcoming: return (localization.string("appointments.confirmed"), .onTertiaryContainer)
        case .completed: return (localization.string("appointments.completed"), .secondary)
        case .cancelled: return (localization.string("appointments.cancelled"), .error)
        }
    }

    private func avatarInitials(_ name: String?) -> String {
        guard let name = name else { return "?" }
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))"
        }
        return String(name.prefix(2)).uppercased()
    }

    // MARK: - FAB

    private var fabButton: some View {
        Button {
            // Schedule new appointment
        } label: {
            HStack(spacing: Dimensions.Space.s) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))
                Text(localization.string("appointments.schedule_new"))
                    .font(Typography.button)
            }
            .foregroundColor(.primary)
            .padding(.horizontal, Dimensions.Space.m)
            .padding(.vertical, Dimensions.Space.m)
            .background(Color.tertiaryFixed)
            .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
            .shadow(color: .black.opacity(0.15), radius: Dimensions.Elevation.l, x: 0, y: Dimensions.Elevation.s)
        }
        .padding(.trailing, Dimensions.Space.m)
        .padding(.bottom, Dimensions.Space.m)
    }

    // MARK: - Formatters

    private static func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, hh:mm a"
        return formatter.string(from: date)
    }
}
