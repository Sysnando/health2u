# iOS App Bug Fixes Plan (9 Issues)

## Context
The iOS app has 9 user-reported issues spanning UI problems, broken upload flows, missing features, and backend gaps. This plan addresses all of them in a dependency-aware order.

---

## Phase 1: Quick iOS-Only UI Fixes

### Issue 4: Add X button to Upload Exam dialog
**File:** `app-ios/Sources/Health2u/Presentation/Upload/UploadView.swift`
- Add `.toolbar` modifier with a `ToolbarItem(placement: .cancellationAction)` containing an "xmark" button that calls `dismiss()`

### Issue 5: Content hidden behind bottom toolbar
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
- Replace `ZStack(alignment: .bottom)` approach with `.safeAreaInset(edge: .bottom)` for the tab bar, so ScrollView content insets are adjusted automatically

### Issue 6: Bottom toolbar height too big
**File:** `app-ios/Sources/Health2u/Presentation/Navigation/RootNavigationView.swift`
- Reduce tab bar padding (top/bottom)
- Reduce AI Upload FAB circle from 52x52 to ~46x46, reduce offset and spacing
- Target: standard ~16px padding or less as requested

### Issue 7: Can't find language change option
**File:** `app-ios/Sources/Health2u/Presentation/Profile/ProfileView.swift`
- The "Logout from Hub" button actually navigates to Settings (where language is). Rename it to "Settings" with a `gearshape` icon and neutral colors
- Add a separate logout action or keep logout inside Settings page

---

## Phase 2: Backend + iOS Data Fixes

### Issue 1: Insights page shows "Unable to load insights"
**Root cause:** Backend returns `created_at` as ISO 8601 timestamptz string, but iOS decoder expects epoch millis (`.millisecondsSince1970`). This causes a `DecodingError`.

**Backend fix:**
- `admin-service/supabase/functions/_shared/dto.ts` — Add `insightDto()` that converts `created_at` to epoch millis (same pattern as `examDto()`)
- `admin-service/supabase/functions/admin/routes/insights.ts` — Apply `insightDto()` to results

### Issue 2: "Choose File" sets hardcoded "selected-file.pdf"
**Files:**
- `app-ios/Sources/Health2u/Presentation/Upload/UploadView.swift` — Replace hardcoded stub with `.fileImporter(isPresented:allowedContentTypes:)` using `.pdf`, `.png`, `.jpeg`
- `app-ios/Sources/Health2u/Presentation/Upload/UploadState.swift` — Add `fileData: Data?` property
- In the fileImporter result handler: read file data via security-scoped URL, set `filename` and `fileData`

### Issue 3: Upload Exam gives "Route not found"
**Root cause:** iOS POSTs to `/exams/upload` (doesn't exist). Backend uses 2-step: `POST /exams/upload-url` then `POST /exams`.

**Files:**
- `app-ios/Sources/Health2u/Data/Remote/APIClient.swift` — Replace `uploadExam` with 3-step flow:
  1. `POST /exams/upload-url` with `{ filename, content_type }` → get `{ upload_url, key }`
  2. `PUT` file bytes directly to presigned R2 URL
  3. `POST /exams` with `{ title, type, date, notes, key }`
- `app-ios/Sources/Health2u/Presentation/Upload/UploadViewModel.swift` — Use `state.fileData` (from Issue 2) instead of `Data("stub-file".utf8)`. Add validation: require file or photo before upload.
- Add `UploadURLResponseDTO` struct

**Depends on:** Issue 2 (file picker)

---

## Phase 3: Full-Stack Feature Additions

### Issue 8: Can't edit gender, height, weight, blood type
**Root cause:** These fields don't exist anywhere — not in DB, backend, or iOS models.

**Changes (in order):**
1. **DB migration** — New file `admin-service/supabase/migrations/0003_user_health_fields.sql`: add `gender text`, `height_cm numeric`, `weight_kg numeric`, `blood_type text` to `users` table
2. **Backend route** — `admin-service/supabase/functions/admin/routes/user.ts`: add fields to SELECT columns and PUT allowlist
3. **iOS User model** — `Domain/Model/User.swift`: add `gender: String?`, `heightCm: Double?`, `weightKg: Double?`, `bloodType: String?`
4. **iOS UserDTO** — `Data/Remote/DTOs/UserDTO.swift`: add matching DTO fields
5. **iOS UserMapper** — `Data/Mapper/UserMapper.swift`: map new fields
6. **iOS UserEntity** — `Data/Local/UserEntity.swift`: add new fields
7. **iOS EditProfileState** — add gender, heightCm, weightKg, bloodType fields
8. **iOS EditProfileViewModel** — populate and save new fields
9. **iOS EditProfileView** — add Picker for gender/blood type, TextField for height/weight
10. **iOS ProfileView** — replace hardcoded "Not set" with actual user data (lines 136-151)

### Issue 9: Upload photo not working (loading indefinitely)
**Root cause:** "Change Photo" is a plain `Text`, not a `Button`. No picker or upload flow exists.

**Changes (in order):**
1. **Backend** — `admin-service/supabase/functions/admin/routes/user.ts`: add `POST /profile/photo-upload-url` route (reuse `presignUpload()` from `r2.ts` with key `profiles/{userId}/{ts}_{filename}`)
2. **Backend** — `admin-service/supabase/functions/_shared/r2.ts`: add `buildProfilePhotoKey()` helper
3. **iOS APIClient** — add `getProfilePhotoUploadURL()` and composite `uploadProfilePhoto()` methods (get URL → PUT to R2 → update profile with URL)
4. **iOS UserRepository** — add `uploadProfilePhoto(imageData:filename:)` method + impl
5. **iOS EditProfileView** — wrap avatar in Button, add `PhotosPicker` (from PhotosUI), show loading overlay during upload
6. **iOS EditProfileState** — add `isUploadingPhoto: Bool`
7. **iOS EditProfileViewModel** — add `uploadPhoto()` method

---

## Implementation Sequence
```
1. Issues 4, 5, 6, 7  (iOS-only, quick wins, can be done in parallel)
2. Issue 1             (backend DTO fix)
3. Issue 2             (file picker)
4. Issue 3             (upload flow, depends on 2)
5. Issue 8             (profile fields, full-stack)
6. Issue 9             (photo upload, full-stack)
```

## Critical Files
| File | Issues |
|------|--------|
| `app-ios/.../Upload/UploadView.swift` | 2, 4 |
| `app-ios/.../Navigation/RootNavigationView.swift` | 5, 6 |
| `app-ios/.../Profile/ProfileView.swift` | 7 |
| `app-ios/.../Data/Remote/APIClient.swift` | 1, 3, 9 |
| `app-ios/.../EditProfile/EditProfileView.swift` | 8, 9 |
| `admin-service/.../routes/insights.ts` | 1 |
| `admin-service/.../routes/user.ts` | 8, 9 |
| `admin-service/.../dto.ts` | 1, 8 |
| `admin-service/supabase/migrations/` | 8 |
| `app-ios/.../Domain/Model/User.swift` | 8 |

## Verification
- **Issue 1:** Open Insights tab → should load insights data
- **Issue 2:** Tap "Choose File" → iOS file picker opens, selected file name shown
- **Issue 3:** Upload an exam (photo or file) → success, no "Route not found"
- **Issue 4:** Upload sheet shows X button top-left, tapping it dismisses
- **Issue 5:** Scroll to bottom of any tab → all content visible above tab bar
- **Issue 6:** Tab bar height is compact, ~icon height + 16px padding
- **Issue 7:** Profile page shows "Settings" button → navigates to Settings with language option
- **Issue 8:** Edit Profile → gender/height/weight/blood type fields editable and saved
- **Issue 9:** Edit Profile → tap avatar → photo picker → photo uploads and displays
