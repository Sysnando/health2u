import SwiftUI

public struct RootNavigationView: View {
    @EnvironmentObject var container: AppContainer
    @State private var selectedTab: Tab = .home
    @State private var showUploadSheet = false

    public init() {}

    enum Tab: Int, CaseIterable {
        case home, exams, insights, records
    }

    public var body: some View {
        Group {
            if container.isAuthenticated {
                authenticatedView
            } else {
                unauthenticatedView
            }
        }
    }

    // MARK: - Unauthenticated Flow (Welcome -> Login)

    private var unauthenticatedView: some View {
        NavigationStack(path: $container.path) {
            WelcomeView(
                onSignIn: { container.path.append(.login) },
                onSignUp: {}
            )
            #if os(iOS)
            .toolbar(.hidden, for: .navigationBar)
            #endif
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .login:
                    LoginView(
                        viewModel: container.makeLoginViewModel(),
                        onSuccess: {
                            container.isAuthenticated = true
                            container.path = []
                        }
                    )
                case .registration:
                    RegistrationView(viewModel: container.makeRegistrationViewModel())
                default:
                    EmptyView()
                }
            }
        }
        .environmentObject(container)
    }

    // MARK: - Authenticated View (Custom 5-Tab Nav with Center FAB)

    private var authenticatedView: some View {
        Group {
            switch selectedTab {
            case .home:
                homeTab
            case .exams:
                examsTab
            case .insights:
                insightsTab
            case .records:
                recordsTab
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .safeAreaInset(edge: .bottom) {
            customTabBar
        }
        .onChange(of: selectedTab) { _, _ in
            container.path = []
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showUploadSheet) {
            NavigationStack {
                UploadView(viewModel: container.makeUploadViewModel())
            }
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 0) {
                // Home Tab
                tabBarItem(
                    icon: "square.grid.2x2",
                    filledIcon: "square.grid.2x2.fill",
                    label: "Home",
                    tab: .home
                )

                // Exams Tab
                tabBarItem(
                    icon: "doc.text",
                    filledIcon: "doc.text.fill",
                    label: "Exams",
                    tab: .exams
                )

                // Center AI Upload FAB
                aiUploadButton
                    .padding(.horizontal, 4)

                // Insights Tab
                tabBarItem(
                    icon: "chart.line.uptrend.xyaxis",
                    filledIcon: "chart.line.uptrend.xyaxis.circle.fill",
                    label: "Insights",
                    tab: .insights
                )

                // Records / Profile Tab
                tabBarItem(
                    icon: "folder",
                    filledIcon: "folder.fill",
                    label: "Records",
                    tab: .records
                )
            }
            .padding(.horizontal, 8)
            .padding(.top, 6)
            .padding(.bottom, 4)
        }
        .background(
            Color.white
                .shadow(.drop(color: Color.black.opacity(0.06), radius: 12, x: 0, y: -4))
        )
    }

    private func tabBarItem(icon: String, filledIcon: String, label: String, tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                if selectedTab == tab {
                    container.path = []  // pop to root
                } else {
                    container.path = []  // reset before switching
                    selectedTab = tab
                }
            }
        } label: {
            VStack(spacing: 2) {
                Image(systemName: selectedTab == tab ? filledIcon : icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == tab ? Color.secondary : Color.onSurfaceVariant.opacity(0.6))
                    .scaleEffect(selectedTab == tab ? 1.1 : 1.0)

                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .tracking(0.3)
                    .foregroundColor(selectedTab == tab ? Color.secondary : Color.onSurfaceVariant.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 0)
        }
        .buttonStyle(.plain)
    }

    private var aiUploadButton: some View {
        Button {
            showUploadSheet = true
        } label: {
            VStack(spacing: 2) {
                ZStack {
                    // Dark gradient circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primary, Color.primaryContainer],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.primary.opacity(0.3), radius: 8, x: 0, y: 4)

                    // White border ring
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 3)
                        .frame(width: 44, height: 44)

                    // Camera icon
                    Image(systemName: "camera.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                .offset(y: -6)

                Text("AI Upload")
                    .font(.system(size: 9, weight: .bold))
                    .tracking(0.8)
                    .textCase(.uppercase)
                    .foregroundColor(Color.primary)
                    .offset(y: -6)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab Content (each with its own NavigationStack)

    private var homeTab: some View {
        NavigationStack(path: $container.path) {
            DashboardView(viewModel: container.makeDashboardViewModel())
                #if os(iOS)
                .toolbar(.hidden, for: .navigationBar)
                #endif
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var examsTab: some View {
        NavigationStack(path: $container.path) {
            ExamsView(viewModel: container.makeExamsViewModel())
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var insightsTab: some View {
        NavigationStack(path: $container.path) {
            InsightsView(viewModel: container.makeInsightsViewModel())
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    private var recordsTab: some View {
        NavigationStack(path: $container.path) {
            ProfileView(viewModel: container.makeProfileViewModel())
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    // MARK: - Shared Navigation Destination Builder

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .welcome:
            WelcomeView(onSignIn: { container.path.append(.login) })
        case .login:
            LoginView(
                viewModel: container.makeLoginViewModel(),
                onSuccess: {
                    container.isAuthenticated = true
                    container.path = []
                }
            )
        case .dashboard:
            DashboardView(viewModel: container.makeDashboardViewModel())
        case .exams:
            ExamsView(viewModel: container.makeExamsViewModel())
        case .examDetail(let id):
            ExamDetailView(viewModel: container.makeExamDetailViewModel(id: id))
        case .insights:
            InsightsView(viewModel: container.makeInsightsViewModel())
        case .upload:
            UploadView(viewModel: container.makeUploadViewModel())
        case .appointments:
            AppointmentsView(viewModel: container.makeAppointmentsViewModel())
        case .appointmentDetail(let id):
            AppointmentDetailView(viewModel: container.makeAppointmentDetailViewModel(id: id))
        case .profile:
            ProfileView(viewModel: container.makeProfileViewModel())
        case .editProfile:
            EditProfileView(viewModel: container.makeEditProfileViewModel())
        case .emergencyContacts:
            EmergencyContactsView(viewModel: container.makeEmergencyContactsViewModel())
        case .settings:
            SettingsView(
                viewModel: container.makeSettingsViewModel(),
                onLogout: {
                    container.isAuthenticated = false
                    container.path = []
                }
            )
        case .registration:
            RegistrationView(viewModel: container.makeRegistrationViewModel())
        case .notifications:
            NotificationsView(viewModel: container.makeNotificationsViewModel())
        }
    }
}
