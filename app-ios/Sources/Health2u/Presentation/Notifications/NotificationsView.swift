import SwiftUI

public struct NotificationsView: View {
    @StateObject private var viewModel: NotificationsViewModel

    public init(viewModel: NotificationsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.notifications.isEmpty {
                LoadingIndicator(message: "Loading notifications...")
            } else if viewModel.state.notifications.isEmpty {
                emptyState
            } else {
                notificationsList
            }
        }
        .background(Color.background.ignoresSafeArea())
        .navigationTitle("Notifications")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .task { await viewModel.load() }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Dimensions.Space.m) {
            Spacer()
            Image(systemName: "bell.slash")
                .font(.system(size: 48))
                .foregroundColor(.onSurfaceVariant.opacity(0.4))
            Text("No notifications yet")
                .font(Typography.titleMedium)
                .foregroundColor(.onSurfaceVariant)
            Text("We'll let you know when something needs your attention.")
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, Dimensions.Space.xl)
            Spacer()
        }
    }

    // MARK: - Notifications List

    private var notificationsList: some View {
        ScrollView {
            LazyVStack(spacing: Dimensions.Space.s) {
                ForEach(viewModel.state.notifications) { notification in
                    notificationCard(notification)
                }
            }
            .padding(.horizontal, Dimensions.Space.m)
            .padding(.vertical, Dimensions.Space.m)
        }
    }

    // MARK: - Notification Card

    private func notificationCard(_ notification: NotificationsState.Notification) -> some View {
        HStack(alignment: .top, spacing: Dimensions.Space.m) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(notification.isRead ? Color.surfaceContainerLow : Color.secondaryFixed.opacity(0.3))
                    .frame(width: 40, height: 40)
                Image(systemName: notification.icon)
                    .font(.system(size: 16))
                    .foregroundColor(notification.isRead ? .onSurfaceVariant : .secondary)
            }

            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                HStack {
                    Text(notification.title)
                        .font(notification.isRead ? Typography.titleSmall : Typography.titleSmall)
                        .fontWeight(notification.isRead ? .regular : .semibold)
                        .foregroundColor(.onSurface)

                    Spacer()

                    if !notification.isRead {
                        Circle()
                            .fill(Color.secondary)
                            .frame(width: 8, height: 8)
                    }
                }

                Text(notification.message)
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                    .lineLimit(2)

                Text(relativeTime(notification.timestamp))
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant.opacity(0.6))
                    .padding(.top, Dimensions.Space.xxs)
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }

    // MARK: - Relative Time

    private func relativeTime(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)

        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        if hours < 24 { return "\(hours)h ago" }
        if days == 1 { return "Yesterday" }
        return "\(days)d ago"
    }
}
