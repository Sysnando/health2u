import SwiftUI

public struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject private var container: AppContainer
    @ObservedObject private var localization = LocalizationManager.shared

    public init(viewModel: DashboardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.recentExams.isEmpty {
                LoadingIndicator(message: localization.string("common.loading"))
            } else if let error = viewModel.state.error, viewModel.state.recentExams.isEmpty {
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
        .task { await viewModel.load() }
    }

    // MARK: - Main Content

    private var content: some View {
        VStack(spacing: 0) {
            topBar
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Dimensions.Space.l) {
                    healthScoreSection
                    criticalVitalsSection
                    recentLabResultsSection
                    insightBanner
                    upcomingCheckupsSection
                }
                .padding(.bottom, 100) // space for bottom bar
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

                        // Notification dot
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

    // MARK: - Health Score

    private var healthScoreSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            Text(localization.string("dashboard.health_score").uppercased())
                .font(Typography.overline)
                .tracking(1.5)
                .foregroundColor(.onSurfaceVariant)

            HStack(alignment: .firstTextBaseline, spacing: Dimensions.Space.xxs) {
                Text("\(viewModel.state.healthScore)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundColor(.onSurface)
                Text("/100")
                    .font(Typography.titleLarge)
                    .foregroundColor(.onSurfaceVariant)
            }

            Text(localization.string("dashboard.cardiovascular_message"))
                .font(Typography.bodyMedium)
                .foregroundColor(.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)

            // Last updated badge
            HStack(spacing: Dimensions.Space.xs) {
                Circle()
                    .fill(Color.onTertiaryContainer)
                    .frame(width: 6, height: 6)
                Text(localization.string("dashboard.last_updated").uppercased())
                    .font(Typography.overline)
                    .tracking(0.5)
                    .foregroundColor(.onSurfaceVariant)
                Text(formattedDate(Date()))
                    .font(Typography.overline)
                    .foregroundColor(.onSurfaceVariant)
            }
            .padding(.horizontal, Dimensions.Space.s)
            .padding(.vertical, Dimensions.Space.xs)
            .background(Color.surfaceContainerLow)
            .cornerRadius(Dimensions.CornerRadius.full)
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Critical Vitals Overview (2x2 Grid)

    private var criticalVitalsSection: some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.m) {
            Text(localization.string("dashboard.vitals_overview").uppercased())
                .font(Typography.overline)
                .tracking(1.5)
                .foregroundColor(.onSurfaceVariant)
                .padding(.horizontal, Dimensions.Space.m)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: Dimensions.Space.m),
                GridItem(.flexible(), spacing: Dimensions.Space.m)
            ], spacing: Dimensions.Space.m) {
                vitalCard(
                    title: localization.string("dashboard.heart_rate"),
                    value: "72",
                    unit: "BPM",
                    icon: "heart.fill",
                    iconColor: .heartRate,
                    showSparkline: true
                )
                vitalCard(
                    title: localization.string("dashboard.blood_pressure"),
                    value: "118/75",
                    unit: "mmHg",
                    icon: "waveform.path.ecg",
                    iconColor: .bloodPressure,
                    showSparkline: false
                )
                vitalCard(
                    title: localization.string("dashboard.blood_sugar"),
                    value: "9.2",
                    unit: "mmol/L",
                    icon: "drop.fill",
                    iconColor: .bloodSugar,
                    showSparkline: false
                )
                vitalCard(
                    title: localization.string("dashboard.spo2"),
                    value: "94",
                    unit: "%",
                    icon: "lungs.fill",
                    iconColor: .oxygen,
                    showSparkline: false
                )
            }
            .padding(.horizontal, Dimensions.Space.m)
        }
    }

    private func vitalCard(
        title: String,
        value: String,
        unit: String,
        icon: String,
        iconColor: Color,
        showSparkline: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: Dimensions.Space.s) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(iconColor)
                Spacer()
                if showSparkline {
                    sparklinePath
                }
            }

            Text(title)
                .font(Typography.labelSmall)
                .foregroundColor(.onSurfaceVariant)

            HStack(alignment: .firstTextBaseline, spacing: Dimensions.Space.xxs) {
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.onSurface)
                Text(unit)
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.xl)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private var sparklinePath: some View {
        // Small decorative sparkline
        Path { path in
            let points: [CGFloat] = [0.5, 0.3, 0.7, 0.2, 0.6, 0.4, 0.8, 0.3]
            let width: CGFloat = 40
            let height: CGFloat = 16
            for (i, y) in points.enumerated() {
                let x = width * CGFloat(i) / CGFloat(points.count - 1)
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: height * (1 - y)))
                } else {
                    path.addLine(to: CGPoint(x: x, y: height * (1 - y)))
                }
            }
        }
        .stroke(Color.heartRate, lineWidth: 1.5)
        .frame(width: 40, height: 16)
    }

    // MARK: - Recent Lab Results

    private var recentLabResultsSection: some View {
        Group {
            if !viewModel.state.recentExams.isEmpty {
                VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                    sectionHeader(title: localization.string("dashboard.recent_labs")) {
                        container.path.append(.exams)
                    }

                    VStack(spacing: Dimensions.Space.s) {
                        ForEach(viewModel.state.recentExams) { exam in
                            labResultCard(exam: exam)
                        }
                    }
                    .padding(.horizontal, Dimensions.Space.m)
                }
            }
        }
    }

    private func labResultCard(exam: Exam) -> some View {
        Button {
            container.path.append(.examDetail(id: exam.id))
        } label: {
            HStack(spacing: Dimensions.Space.m) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.m)
                        .fill(Color.secondaryFixed.opacity(0.3))
                        .frame(width: 40, height: 40)
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                    Text(exam.title)
                        .font(Typography.titleSmall)
                        .foregroundColor(.onSurface)
                    Text(exam.type)
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: Dimensions.Space.xxs) {
                    Text(formattedShortDate(exam.date))
                        .font(Typography.labelSmall)
                        .foregroundColor(.onSurfaceVariant)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.outlineVariant)
                }
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Insight Banner

    private var insightBanner: some View {
        Group {
            if let insight = viewModel.state.insights.first {
                VStack(alignment: .leading, spacing: Dimensions.Space.s) {
                    HStack(spacing: Dimensions.Space.s) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.onTertiaryContainer)
                        Text(insight.title)
                            .font(Typography.titleSmall)
                            .foregroundColor(.onSurface)
                        Spacer()
                    }
                    Text(insight.description)
                        .font(Typography.bodySmall)
                        .foregroundColor(.onSurfaceVariant)
                        .lineLimit(2)
                }
                .padding(Dimensions.Space.m)
                .background(
                    RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                        .fill(Color.tertiaryFixed.opacity(0.15))
                        .overlay(
                            RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl)
                                .stroke(Color.tertiaryFixed.opacity(0.4), lineWidth: 1)
                        )
                )
                .padding(.horizontal, Dimensions.Space.m)
            }
        }
    }

    // MARK: - Upcoming Checkups

    private var upcomingCheckupsSection: some View {
        Group {
            if !viewModel.state.upcomingAppointments.isEmpty {
                VStack(alignment: .leading, spacing: Dimensions.Space.m) {
                    sectionHeader(title: localization.string("dashboard.upcoming")) {
                        container.path.append(.appointments)
                    }

                    VStack(spacing: Dimensions.Space.s) {
                        ForEach(viewModel.state.upcomingAppointments.prefix(2)) { appt in
                            appointmentPreviewCard(appt: appt)
                        }
                    }
                    .padding(.horizontal, Dimensions.Space.m)
                }
            }
        }
    }

    private func appointmentPreviewCard(appt: Appointment) -> some View {
        Button {
            container.path.append(.appointmentDetail(id: appt.id))
        } label: {
            HStack(spacing: Dimensions.Space.m) {
                // Date column
                VStack(spacing: Dimensions.Space.xxs) {
                    Text(dayOfMonth(appt.dateTime))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.secondary)
                    Text(monthAbbrev(appt.dateTime))
                        .font(Typography.labelSmall)
                        .foregroundColor(.onSurfaceVariant)
                }
                .frame(width: 44)

                Rectangle()
                    .fill(Color.outlineVariant)
                    .frame(width: 1, height: 36)

                VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                    Text(appt.title)
                        .font(Typography.titleSmall)
                        .foregroundColor(.onSurface)
                    if let doctor = appt.doctorName {
                        Text(doctor)
                            .font(Typography.bodySmall)
                            .foregroundColor(.onSurfaceVariant)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.outlineVariant)
            }
            .padding(Dimensions.Space.m)
            .background(Color.surfaceContainerLowest)
            .cornerRadius(Dimensions.CornerRadius.l)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section Header

    private func sectionHeader(title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(Typography.titleMedium)
                .foregroundColor(.onSurface)
            Spacer()
            Button(action: action) {
                HStack(spacing: Dimensions.Space.xxs) {
                    Text(localization.string("dashboard.see_all"))
                        .font(Typography.labelMedium)
                        .foregroundColor(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, Dimensions.Space.m)
    }

    // MARK: - Date Helpers

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

    private func formattedShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func dayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private func monthAbbrev(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }
}
