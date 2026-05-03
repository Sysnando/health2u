# iOS Bug Fixes & New Screens Plan

## Context
After the UI redesign, several navigation and interaction bugs remain, plus two new screens are needed (Registration and Notifications).

---

## Bug Fixes

### 1. Home Tab Button Should Navigate to Main Screen
**Problem:** Tapping the Home tab when already on a sub-screen doesn't pop back to the Dashboard.
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
**Fix:** In `tabBarItem` button action, if the tab is already selected, reset that tab's navigation path (pop to root). For the home tab, this means `container.path = []`.

### 2. Bottom Bar Height Too Large
**Problem:** The custom tab bar is too tall — excessive padding above/below icons.
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
**Fix:** Reduce `.padding(.top, 8)` to `.padding(.top, 4)` and reduce the AI Upload button offset from `-16` to `-12`. Make icon size `20` instead of `22`. Reduce label font to `9pt`. Target total bar height ~50pt (matching standard iOS tab bar) plus safe area.

### 3. Plus Button on Exams Page Not Working
**Problem:** The plus button uses `container.path.append(.upload)` but the Exams tab has its own NavigationStack without a shared path binding — it doesn't use `container.path`.
**File:** `app-ios/Sources/Health2u/Presentation/Exams/ExamsView.swift`
**Fix:** Change to present the upload as a sheet (like the center FAB does) using `@State private var showUploadSheet = false` and `.sheet(isPresented:)`. Or use a local `@State private var navPath = NavigationPath()` and NavigationLink. The simplest fix: show upload as a sheet with `container.makeUploadViewModel()`.

### 4. View Report Link Not Working
**Problem:** The "View Report" text in exam cards is just a `Text` label (lines 213-217), not a tappable element. The card itself IS a Button that navigates to examDetail, but the "View Report" text doesn't do anything extra.
**File:** `app-ios/Sources/Health2u/Presentation/Exams/ExamsView.swift`
**Fix:** The entire card is already a `Button` that navigates to `.examDetail(id:)`. Make "View Report" visually look like a link but the tap target is the whole card. OR make "View Report" specifically navigate. The card button approach is correct — just ensure the navigation actually works by fixing the NavigationStack path issue (same root cause as #3).

### 5. Filter Pills Not Working on Exams Screen
**Problem:** The filter chips call `viewModel.setFilter()` which calls `viewModel.load()`. The `load()` method fetches from the repository with the filter. This should work. The issue is likely that the repository's `fetchExams(filter:)` isn't filtering properly, OR the active filter visual state isn't updating.
**File:** `app-ios/Sources/Health2u/Presentation/Exams/ExamsView.swift`
**Fix:** Verify the active chip visual state uses `viewModel.state.filter` correctly. Currently the chip comparison is `viewModel.state.filter == nil && option == "All Records"` for the first chip, and `viewModel.state.filter == option` for others. This looks correct. The likely issue is that ExamsView's NavigationStack doesn't share `container.path`, so navigation within the exams tab may be broken. Ensure filter state changes trigger a UI refresh by verifying the `@StateObject` binding.

### 6. Bottom Bar Showing During Login
**Problem:** The custom tab bar appears on the login screen because the authenticated/unauthenticated switch might not be working, OR the tab bar ZStack is leaking.
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
**Fix:** The current code has `if container.isAuthenticated { authenticatedView } else { unauthenticatedView }`. The unauthenticated view should NOT show the tab bar. Verify this conditional is working. If the issue is that `container.isAuthenticated` starts as `true`, check `AppContainer` init.

### 7. Top Bar and Bottom Bar Should Be Sticky
**Problem:** The custom top bar in Dashboard scrolls with the content instead of staying fixed.
**File:** `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift`
**Fix:** Move the `topBar` out of the `ScrollView` and place it above in a `VStack`. Structure should be: `VStack { topBar; ScrollView { content } }` instead of `ScrollView { VStack { topBar; content } }`. Bottom bar is already fixed (it's in the ZStack overlay in RootNavigationView).

### 8. Remove Back Button from Login Page
**Problem:** The login page shows a navigation back button (since it's pushed onto the NavigationStack from WelcomeView).
**File:** `app-ios/Sources/Health2u/Presentation/Login/LoginView.swift`
**Fix:** Add `.navigationBarBackButtonHidden(true)` to the login view body. The current code has `.navigationBarBackButtonHidden(false)` — change to `true`.

---

## New Screens

### 9. Registration Page
**New files to create:**
- `app-ios/Sources/Health2u/Presentation/Registration/RegistrationView.swift`
- `app-ios/Sources/Health2u/Presentation/Registration/RegistrationViewModel.swift`
- `app-ios/Sources/Health2u/Presentation/Registration/RegistrationState.swift`

**Files to modify:**
- `app-ios/Sources/Health2u/Presentation/Navigation/Route.swift` — Add `.registration` case
- `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift` — Handle `.registration` route
- `app-ios/Sources/Health2u/Presentation/Login/LoginView.swift` — "Join Hub" button navigates to registration instead of showing alert
- `app-ios/Sources/Health2u/App/AppContainer.swift` — Add `makeRegistrationViewModel()` factory
- `app-ios/Sources/Health2u/Domain/Repository/AuthRepository.swift` — Add `register(name:email:password:)` method
- `app-ios/Sources/Health2u/Data/Repository/AuthRepositoryImpl.swift` — Implement register

**Design:** Match the login page style but with:
- "Create Account" headline
- Name, Email, Password, Confirm Password fields
- "Create Account" primary button
- "Already have an account? Sign In" link
- Terms checkbox

**Backend endpoint:** `POST /auth/register` with `{ name, email, password }` — check if this exists in the backend. If not, the registration can be client-side only (calling the existing login after creation) or show "Coming Soon" if no backend support.

### 10. Notifications Page
**New files to create:**
- `app-ios/Sources/Health2u/Presentation/Notifications/NotificationsView.swift`
- `app-ios/Sources/Health2u/Presentation/Notifications/NotificationsViewModel.swift`
- `app-ios/Sources/Health2u/Presentation/Notifications/NotificationsState.swift`

**Files to modify:**
- `app-ios/Sources/Health2u/Presentation/Navigation/Route.swift` — Add `.notifications` case
- `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift` — Handle `.notifications` route
- `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift` — Bell icon navigates to notifications instead of showing alert
- `app-ios/Sources/Health2u/App/AppContainer.swift` — Add `makeNotificationsViewModel()` factory

**Design:** Simple list of notification cards:
- Header: "Notifications" title with back button
- Notification cards: icon + title + message + timestamp
- Empty state: "No notifications yet"
- Since there's no backend notifications endpoint, show mock/local notifications based on app events (upcoming appointments, exam results ready, etc.)

---

## Files Summary

| File | Changes |
|------|---------|
| `RootNavigationView.swift` | Fix #1 (home reset), #2 (bar height), #6 (login bar), handle new routes |
| `ExamsView.swift` | Fix #3 (plus button), #4 (view report), #5 (filters) |
| `DashboardView.swift` | Fix #7 (sticky top bar), #10 (bell → notifications) |
| `LoginView.swift` | Fix #8 (hide back button), #9 (Join Hub → registration) |
| `Route.swift` | Add `.registration`, `.notifications` |
| `AppContainer.swift` | Add factory methods for new ViewModels |
| NEW: `Registration/` | RegistrationView, ViewModel, State |
| NEW: `Notifications/` | NotificationsView, ViewModel, State |
| `AuthRepository.swift` | Add register method (if backend supports it) |
| `AuthRepositoryImpl.swift` | Implement register |

## DO NOT TOUCH
- Domain models, Data layer (except AuthRepository for register)
- UI/Theme, UI/Components
- Backend (admin-service)
- Portal, Android app

## Verification
1. `cd app-ios && swift build` — must compile
2. `xcodegen generate` — regenerate Xcode project
3. Tap Home tab while on a sub-screen → pops to Dashboard
4. Bottom bar height is compact (~50pt + safe area)
5. Plus button on Exams → opens Upload sheet
6. View Report on exam card → navigates to ExamDetail
7. Filter pills on Exams → list filters correctly
8. Login page has NO bottom tab bar and NO back button
9. Dashboard top bar stays fixed while scrolling
10. "Join Hub" on login → opens Registration page
11. Bell icon on Dashboard → opens Notifications page
