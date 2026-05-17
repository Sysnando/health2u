import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared
    @State private var showLockedToast = false

    public init(viewModel: DashboardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.userName.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.userName.isEmpty {
                EmptyState(
                    icon: "exclamationmark.triangle",
                    title: localization.string("common.error"),
                    message: error,
                    actionTitle: localization.string("common.retry"),
                    action: { Task { await viewModel.load() } }
                )
            } else {
                content
            }
        }
        .background(Color.background.ignoresSafeArea())
        .task(id: container.examsRefreshTrigger) { await viewModel.load() }
    }

    // MARK: - Main Content

    private var content: some View {
        VStack(spacing: 0) {
            topBar

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Dimensions.Space.l) {
                    // Greeting
                    Text(localization.string("dashboard.greeting") + ", \(viewModel.state.userName)")
                        .font(Typography.headlineMedium)
                        .foregroundColor(.onSurface)
                        .padding(.horizontal, Dimensions.Space.m)
                        .padding(.top, Dimensions.Space.m)

                    // Vitals Overview
                    vitalsSection

                    // 2x3 Grid
                    gridSection
                }
                .padding(.bottom, 100)
            }
        }
        .overlay(alignment: .bottom) {
            if showLockedToast {
                toastView
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 110)
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Text("2YH")
                .font(.system(size: 14, weight: .bold))
                .tracking(3)
                .foregroundColor(.primary)

            Spacer()

            HStack(spacing: Dimensions.Space.m) {
                Button(action: { container.path.append(.notifications) }) {
                    ZStack {
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundColor(.onSurface)

                        Circle()
                            .fill(Color.error)
                            .frame(width: 8, height: 8)
                            .offset(x: 7, y: -7)
                    }
                }

                NavigationLink(value: Route.profile) {
                    Circle()
                        .fill(Color.secondaryContainer)
                        .frame(width: 34, height: 34)
                        .overlay(
                            Text(viewModel.state.userName.prefix(1).uppercased())
                                .font(Typography.labelLarge)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
        .padding(.top, Dimensions.Space.s)
    }

    // MARK: - Vitals Section

    private var vitalsSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("dashboard.vitals_overview"))
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
                .padding(.horizontal, Dimensions.Space.m)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: Dimensions.Space.m),
                GridItem(.flexible(), spacing: Dimensions.Space.m)
            ], spacing: Dimensions.Space.m) {
                vitalTile(kind: .heartRate, icon: "heart.fill", title: localization.string("dashboard.heart_rate"))
                vitalTile(kind: .bloodPressure, icon: "waveform.path.ecg", title: localization.string("dashboard.blood_pressure"))
                vitalTile(kind: .bloodSugar, icon: "drop.fill", title: localization.string("dashboard.blood_sugar"))
                vitalTile(kind: .spo2, icon: "lungs.fill", title: localization.string("dashboard.spo2"))
            }
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    @ViewBuilder
    private func vitalTile(kind: ExamBiomarker.Kind, icon: String, title: String) -> some View {
        let biomarker = viewModel.state.latestBiomarkers[kind]
        if let biomarker {
            Button(action: { container.path.append(.examDetail(id: biomarker.sourceExamId)) }) {
                vitalTileContent(icon: icon, title: title, biomarker: biomarker)
            }
            .buttonStyle(.plain)
        } else {
            vitalTileContent(icon: icon, title: title, biomarker: nil)
        }
    }

    private func vitalTileContent(icon: String, title: String, biomarker: ExamBiomarker?) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.xs) {
            HStack(spacing: Dimensions.Space.xs) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                Text(title)
                    .font(Typography.labelMedium)
                    .foregroundColor(.onSurfaceVariant)
                Spacer()
                if let flag = biomarker?.flag {
                    Circle()
                        .fill(flagColor(flag))
                        .frame(width: 8, height: 8)
                }
            }

            if let biomarker {
                Text("\(biomarker.value)\(biomarker.unit.map { " \($0)" } ?? "")")
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurface)
                    .lineLimit(1)
                Text(localization.string("dashboard.from_exam"))
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
                    .lineLimit(1)
            } else {
                Text("--")
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurfaceVariant)
                Text(" ")
                    .font(Typography.bodySmall)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private func flagColor(_ flag: String) -> Color {
        switch flag.lowercased() {
        case "normal": return .onTertiaryContainer
        case "high": return .error
        case "low": return .tertiaryFixed
        default: return .onSurfaceVariant
        }
    }

    // MARK: - Grid Section

    private var gridSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: Dimensions.Space.m),
            GridItem(.flexible(), spacing: Dimensions.Space.m)
        ], spacing: Dimensions.Space.m) {
            // Active cards
            gridCard(
                icon: "cross.case.fill",
                title: localization.string("dashboard.my_health"),
                isLocked: false
            ) {
                container.path.append(.myHealth)
            }

            gridCard(
                icon: "doc.text.fill",
                title: localization.string("dashboard.my_exams"),
                isLocked: false
            ) {
                container.path.append(.exams)
            }

            // Locked cards
            gridCard(
                icon: "syringe.fill",
                title: localization.string("dashboard.my_vaccines"),
                isLocked: true
            ) {
                showLockedToastBriefly()
            }

            gridCard(
                icon: "pills.fill",
                title: localization.string("dashboard.medications"),
                isLocked: true
            ) {
                showLockedToastBriefly()
            }

            gridCard(
                icon: "calendar",
                title: localization.string("dashboard.appointments"),
                isLocked: true
            ) {
                showLockedToastBriefly()
            }

            gridCard(
                icon: "ellipsis.circle.fill",
                title: localization.string("dashboard.others"),
                isLocked: true
            ) {
                showLockedToastBriefly()
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Grid Card

    private func gridCard(icon: String, title: String, isLocked: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: Dimensions.Space.m) {
                ZStack {
                    Image(systemName: icon)
                        .font(.system(size: 28))
                        .foregroundColor(isLocked ? .onSurfaceVariant : .secondary)

                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.onSurfaceVariant)
                            .offset(x: 16, y: -14)
                    }
                }

                Text(title)
                    .font(Typography.titleMedium)
                    .foregroundColor(isLocked ? .onSurfaceVariant : .onSurface)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.xl)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
            .opacity(isLocked ? 0.4 : 1.0)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Toast

    private var toastView: some View {
        HStack(spacing: Dimensions.Space.s) {
            Image(systemName: "lock.fill")
                .font(.system(size: 14))
            Text(localization.string("dashboard.coming_soon"))
                .font(Typography.labelMedium)
        }
        .foregroundColor(.surfaceContainerLowest)
        .padding(.horizontal, Dimensions.Space.l)
        .padding(.vertical, Dimensions.Space.m)
        .background(Color.onSurface.opacity(0.85))
        .cornerRadius(Dimensions.CornerRadius.full)
    }

    private func showLockedToastBriefly() {
        withAnimation(.easeInOut(duration: 0.25)) {
            showLockedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.25)) {
                showLockedToast = false
            }
        }
    }
}
