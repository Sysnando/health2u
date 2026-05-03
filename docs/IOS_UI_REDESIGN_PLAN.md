# iOS App UI Redesign — Match Stitch Designs

## Context
The iOS app's current UI doesn't match the Stitch design system (Project ID: 4316282056652774057). The designs use a specific Material Design 3 color palette, Manrope/Inter typography, and a clean clinical aesthetic with dark navy primary (#00020a), blue secondary (#0058bc), and mint green accents (#6ffbbe/#009768). The current iOS theme uses different colors (primaryBlue #1976D2, secondaryTeal #008B7B) and the layouts don't match the designs.

## Design System Extracted from Stitch

### Colors (MD3 palette)
- **Primary:** `#00020a` (near-black navy)
- **Primary Container:** `#001b44` (dark navy)
- **Secondary:** `#0058bc` (deep blue)
- **Secondary Container:** `#0070eb` (bright blue)
- **Tertiary/Accent green:** `#009768` / `#6ffbbe` (mint green)
- **Background:** `#f7f9fb`
- **Surface:** `#f7f9fb`, Surface-low: `#f2f4f6`, Surface-high: `#e6e8ea`
- **On-Surface:** `#191c1e`
- **On-Surface-Variant:** `#44474f`
- **Outline:** `#75777f`, Outline-variant: `#c5c6d0`
- **Error:** `#ba1a1a`

### Typography
- **Headlines:** Manrope (extrabold/bold, tight tracking)
- **Body/Labels:** Inter (regular/medium/semibold)

### Key Design Patterns (from screenshots)
- **Bottom nav:** 4 tabs — Home, Appointments, Vitals, Profile
- **Cards:** White bg, subtle border, rounded corners (xl/2xl)
- **Health score:** Large "84/100" with circular progress indicator
- **Vitals grid:** 2x2 cards with heart rate, blood pressure, glucose, SpO2
- **Exam cards:** Icon + title + date + key metrics inline
- **Login:** Centered card, Google + Apple sign-in buttons, minimal
- **Profile:** Dark gradient header with avatar, info cards below

## Screens to Rebuild (12 View files)

### Priority 1 — Core Flow
1. **LoginView** — Centered card, branding, Google/Apple buttons, "Secured Access" divider
2. **DashboardView** — Health score card, vitals grid, recent labs, vitamin insight card, upcoming appointments
3. **ExamsView** — Filter chips (All Records, Lab Results, Radiology), search bar, exam cards with metrics

### Priority 2 — Tab Screens
4. **AppointmentsView** — Upcoming/Past tabs, appointment cards with doctor, date, location, status badge
5. **InsightsView** — Metabolic stability card, bar chart, predictive longevity banner, recent reports
6. **ProfileView** — Dark gradient header, avatar, user info, medical records chips, emergency contacts

### Priority 3 — Secondary Screens
7. **SettingsView** — Account/Preferences/Data sections, toggle switches, export/delete buttons
8. **WelcomeView** — Shield icon, "MYHEALTHHUB" branding, loading bar, "SECURE DATA SYNC ACTIVE"
9. **EmergencyContactsView** — Contact cards with phone/relationship
10. **EditProfileView** — Form fields matching design
11. **ExamDetailView** — Detail view with metrics
12. **AppointmentDetailView** — Detail view

## Files to Modify

### Theme (update colors to match MD3 palette)
- `app-ios/Sources/Health2u/UI/Theme/Color+Health2u.swift` — Replace entire color set with Stitch MD3 palette
- `app-ios/Sources/Health2u/UI/Theme/Typography+Health2u.swift` — Update to Manrope/Inter

### Components (update to match design patterns)
- `app-ios/Sources/Health2u/UI/Components/Cards/HealthSummaryCard.swift` — Match vitals grid style
- `app-ios/Sources/Health2u/UI/Components/Cards/ExamCard.swift` — Match exam card with metrics
- `app-ios/Sources/Health2u/UI/Components/Cards/AppointmentCard.swift` — Match appointment card style
- `app-ios/Sources/Health2u/UI/Components/Buttons/PrimaryButton.swift` — Match dark primary style
- `app-ios/Sources/Health2u/UI/Components/Inputs/H2UTextField.swift` — Match input style

### Screen Views (rebuild layouts)
- `app-ios/Sources/Health2u/Presentation/Login/LoginView.swift`
- `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift`
- `app-ios/Sources/Health2u/Presentation/Exams/ExamsView.swift`
- `app-ios/Sources/Health2u/Presentation/Appointments/AppointmentsView.swift`
- `app-ios/Sources/Health2u/Presentation/Insights/InsightsView.swift`
- `app-ios/Sources/Health2u/Presentation/Profile/ProfileView.swift`
- `app-ios/Sources/Health2u/Presentation/Settings/SettingsView.swift`
- `app-ios/Sources/Health2u/Presentation/Welcome/WelcomeView.swift`
- `app-ios/Sources/Health2u/Presentation/EmergencyContacts/EmergencyContactsView.swift`
- `app-ios/Sources/Health2u/Presentation/EditProfile/EditProfileView.swift`

### Navigation (update bottom nav tabs)
- `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift` — 4-tab bottom nav: Home, Appointments, Vitals, Profile

### DO NOT TOUCH
- Domain layer (models, repositories, use cases)
- Data layer (API client, DTOs, mappers, local DB)
- ViewModels and State files (keep same data contracts)
- App/AppContainer.swift (DI)
- Tests

## Implementation Order
1. Theme files first (colors + typography) — foundation for everything
2. Reusable components (buttons, cards, inputs)
3. Navigation (bottom tab bar)
4. Screen views (Login → Welcome → Dashboard → Exams → Appointments → Insights → Profile → Settings → EmergencyContacts → EditProfile)

## Verification
1. Build: `cd app-ios && swift build`
2. Run on device/simulator and visually compare each screen to the Stitch screenshots
3. Verify all tabs navigate correctly
4. Verify login flow works end-to-end with local backend
