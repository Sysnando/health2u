# iOS Bug Fixes & Feature Plan

## Bug Fixes

### 1. Bottom Toolbar Not Touching Screen Bottom
**Problem:** The custom tab bar has a gap between it and the bottom edge of the screen.
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
**Fix:** Remove extra bottom padding logic. Use `.ignoresSafeArea(edges: .bottom)` on the tab bar background so it extends into the safe area. The content padding should use the safe area inset but the background should bleed through.

### 2. Profile Button in Top Right Not Working
**Problem:** The user avatar / profile button on the Dashboard top bar doesn't navigate to the Profile screen.
**File:** `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift`
**Fix:** Wrap the avatar button in a `NavigationLink(value: Route.profile)` or use programmatic navigation via `container.path.append(.profile)`. Requires access to `@EnvironmentObject var container: AppContainer`.

### 3. Notifications Button Not Working
**Problem:** The notification bell icon on the Dashboard has no action.
**File:** `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift`
**Fix:** For now, show an alert or sheet indicating "Notifications coming soon". Future: implement a notifications list view.

## Features

### 4. Multi-Language Support (i18n)
**Goal:** Support English, Spanish, Portuguese (BR), Portuguese (PT), and French — matching the portal's language set.
**Approach:**
- Add `Localizable.strings` files for each locale: `en`, `es`, `pt-BR`, `pt`, `fr`
- Create a `LocalizationManager` or use SwiftUI's built-in `LocalizedStringKey`
- Wrap all user-facing strings in `NSLocalizedString()` or `String(localized:)`
- Add language selector in Settings (already has a "Language" row in the design)
- Store language preference in `UserDefaults`
**Files to create:**
- `app-ios/Sources/Health2u/Resources/en.lproj/Localizable.strings`
- `app-ios/Sources/Health2u/Resources/es.lproj/Localizable.strings`
- `app-ios/Sources/Health2u/Resources/pt-BR.lproj/Localizable.strings`
- `app-ios/Sources/Health2u/Resources/pt.lproj/Localizable.strings`
- `app-ios/Sources/Health2u/Resources/fr.lproj/Localizable.strings`
**Files to modify:**
- All View files (replace hardcoded strings with localized keys)
- `app-ios/Sources/Health2u/Presentation/Settings/SettingsView.swift` (language picker)
- `app-ios/project.yml` (add resource references)

### 5. Upload: Title Not Required, Backend Interprets Exam Name
**Problem:** The upload form currently requires a title. The backend AI processes the document and assigns a proper name.
**Files:**
- `app-ios/Sources/Health2u/Presentation/Upload/UploadView.swift` — Make title field optional, show placeholder like "Will be auto-detected"
- `app-ios/Sources/Health2u/Presentation/Upload/UploadState.swift` — Title should default to empty and not be validated as required
- `app-ios/Sources/Health2u/Presentation/Upload/UploadViewModel.swift` — Remove title validation before upload, send empty/nil title to backend

### 6. Camera Capture for Document Upload
**Goal:** Allow users to take a photo of a document (exam, prescription, lab result) and upload it directly.
**Approach:**
- Use `UIImagePickerController` (camera source) or `PHPickerViewController` wrapped in a SwiftUI `UIViewControllerRepresentable`
- Add camera permission to Info.plist: `NSCameraUsageDescription`
- In the Upload flow, offer two options: "Take Photo" and "Choose File"
- Convert captured `UIImage` to JPEG data, create a temporary file, then upload via the existing exam upload flow (presigned URL → R2)
**Files to create:**
- `app-ios/Sources/Health2u/UI/Components/Camera/CameraPickerView.swift` — UIViewControllerRepresentable wrapper
**Files to modify:**
- `app-ios/Sources/Health2u/Presentation/Upload/UploadView.swift` — Add camera option alongside file picker
- `app-ios/Sources/Health2u/Presentation/Upload/UploadViewModel.swift` — Handle image data upload
- `app-ios/Sources/Health2u/Presentation/Upload/UploadState.swift` — Add imageData property
- `app-ios/project.yml` — Add `NSCameraUsageDescription` to Info.plist properties

### 7. Rebrand to "Health in Your Hands (2YH)"
**Goal:** Replace all "MyHealthHub" references with the new brand "2YH" / "Health in Your Hands".
**Files to modify:**
- All View files containing "MyHealthHub" or "MYHEALTHHUB" text
- `app-ios/Sources/Health2u/Presentation/Welcome/WelcomeView.swift` — Splash screen branding
- `app-ios/Sources/Health2u/Presentation/Login/LoginView.swift` — Login branding
- `app-ios/Sources/Health2u/Presentation/Dashboard/DashboardView.swift` — Top bar brand
- `app-ios/Sources/Health2u/Presentation/Insights/InsightsView.swift` — Header brand
- `app-ios/Sources/Health2u/Presentation/Profile/ProfileView.swift` — Profile header brand
- `app-ios/Sources/Health2u/Presentation/Settings/SettingsView.swift` — Settings brand + footer
- Localization files (once created) — all brand references

## Implementation Order
1. Bug fixes first (#1, #2, #3) — quick wins
2. Rebranding (#7) — search-and-replace across views
3. Upload improvements (#5, #6) — connected features
4. Multi-language support (#4) — largest scope, do last

## DO NOT TOUCH
- Domain layer (models, repositories, use cases)
- Data layer (API client, DTOs, mappers, local DB)
- Backend (admin-service)
- Portal (landing page)
- Android app

## Verification
1. `cd app-ios && swift build` — must compile
2. Run on physical device — verify tab bar touches bottom edge
3. Tap profile avatar — should navigate to profile
4. Tap notification bell — should show alert/sheet
5. Upload a document without title — should succeed
6. Take a photo and upload — should succeed
7. Verify "2YH" branding appears on all screens
8. Switch language in Settings — verify UI updates
