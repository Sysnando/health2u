import SwiftUI

public struct RootNavigationView: View {
    @EnvironmentObject var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var selectedTab: Tab = .home
    @State private var showUploadSheet = false

    public init() {}

    enum Tab: Int, CaseIterable {
        case home, exams
    }

    public var body: some View {
        Group {
            if !container.isReady {
                splashView
            } else if container.isAuthenticated {
                authenticatedView
            } else {
                unauthenticatedView
            }
        }
    }

    // MARK: - Splash (shown while checking auth state)

    private var splashView: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.secondary)
                        .frame(width: 72, height: 72)
                    Image(systemName: "heart.text.square.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.white)
                }
                Text("2YH")
                    .font(.system(size: 20, weight: .bold))
                    .tracking(6)
                    .foregroundColor(.primary)
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
        .sheet(isPresented: $showUploadSheet, onDismiss: {
            // Defensive: if the upload succeeded server-side but iOS timed out
            // (long PDF analysis), the success callback never fired. Refresh
            // on every dismiss to reconcile the list.
            print("🔄 [RootNav] Upload sheet dismissed (selectedTab=\(self.selectedTab)) — calling notifyExamsChanged()")
            container.notifyExamsChanged()
        }) {
            NavigationStack {
                UploadView(viewModel: container.makeUploadViewModel())
            }
        }
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(alignment: .center, spacing: 0) {
            tabBarItem(
                icon: "square.grid.2x2",
                filledIcon: "square.grid.2x2.fill",
                label: localization.string("tab.home"),
                tab: .home
            )

            aiUploadButton

            tabBarItem(
                icon: "doc.text",
                filledIcon: "doc.text.fill",
                label: localization.string("tab.exams"),
                tab: .exams
            )
        }
        .padding(.horizontal, 8)
        .padding(.top, 4)
        .padding(.bottom, 2)
        .background(
            Color.white
                .shadow(.drop(color: Color.black.opacity(0.06), radius: 8, x: 0, y: -3))
        )
    }

    private func tabBarItem(icon: String, filledIcon: String, label: String, tab: Tab) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                if selectedTab == tab {
                    container.path = []
                } else {
                    container.path = []
                    selectedTab = tab
                }
            }
        } label: {
            VStack(spacing: 1) {
                Image(systemName: selectedTab == tab ? filledIcon : icon)
                    .font(.system(size: 18))
                    .foregroundColor(selectedTab == tab ? Color.secondary : Color.onSurfaceVariant.opacity(0.6))

                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .tracking(0.3)
                    .foregroundColor(selectedTab == tab ? Color.secondary : Color.onSurfaceVariant.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var aiUploadButton: some View {
        Button {
            showUploadSheet = true
        } label: {
            VStack(spacing: 1) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primary, Color.primaryContainer],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .shadow(color: Color.primary.opacity(0.25), radius: 6, x: 0, y: 3)

                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .frame(width: 36, height: 36)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .offset(y: -4)

                Text(localization.string("tab.ai_upload"))
                    .font(.system(size: 9, weight: .bold))
                    .tracking(0.8)
                    .textCase(.uppercase)
                    .foregroundColor(Color.primary)
                    .offset(y: -4)
            }
            .frame(maxWidth: .infinity)
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
        case .myHealth:
            MyHealthView(viewModel: container.makeMyHealthViewModel())
        case .examCategory(let category):
            ExamCategoryListView(categoryId: category, viewModel: container.makeExamsViewModel())
        case .allergies:
            AllergiesView(viewModel: container.makeAllergiesViewModel())
        }
    }
}
