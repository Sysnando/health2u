# Health2U Design Assets

This directory contains all design assets downloaded from the Stitch project.

## Stitch Project Details

- **Project ID:** 4316282056652774057
- **Project Name:** My Health Hub
- **Total Screens:** 16

## Directory Structure

```
design-assets/
├── images/        # PNG screenshots of each screen
├── code/          # HTML/code exports from Stitch
├── specs/         # JSON specifications for each screen
└── download-stitch-assets.js  # Download script
```

## Downloading Assets

### Prerequisites

1. **Node.js 18+** installed
2. **Stitch API Key** from your Stitch account
3. **@google/stitch-sdk** npm package

### Installation

```bash
npm install @google/stitch-sdk
```

### Usage

Set your Stitch API key and run the download script:

```bash
export STITCH_API_KEY=your_api_key_here
node download-stitch-assets.js
```

Or in one line:

```bash
STITCH_API_KEY=your_api_key_here node download-stitch-assets.js
```

### What Gets Downloaded

For each of the 16 screens:
- **PNG image** - Visual screenshot of the design
- **HTML/code** - Code export (if available)
- **JSON spec** - Design specifications (colors, spacing, typography)

## Screen List

| # | Screen Name | Stitch ID |
|---|-------------|-----------|
| 1 | Design System | asset-stub-assets-e59fec01f99a454b809ebd6013fd7a6e-1774120825936 |
| 2 | AI Upload Processing | 753b673616774feaafd6fa855bacaf99 |
| 3 | Dashboard | 8daf7fa7ee8245f9ac14e897ae4f9914 |
| 4 | Exams | a953f4d1d29e4083960125c0b4384177 |
| 5 | Insights | e06d2a0feccc4b81ac13d05a628763a0 |
| 6 | Welcome | a681a6276a0d44838c77c74188f6d5e0 |
| 7 | Login | e6dfd2760ed34e46996944be7ff26da2 |
| 8 | Onboarding: Track Health | b110dc8b16f1469ba325c0788242420f |
| 9 | Onboarding: Stay Organized | 6ceabde3d11943c58be6802e62136256 |
| 10 | Onboarding: Secure & Private | 3353b894431549ea9c732f2321c9e741 |
| 11 | User Profile | 340ec2c957c64bc7a55d49b92ec861b2 |
| 12 | Edit Profile | 7536d063fa1944fa816d05ea36ad1805 |
| 13 | Emergency Contacts (Empty) | 47aba8be46a0422eb02407c68ebf3e74 |
| 14 | Emergency Contacts | 0ddda2d0705d4cf9af63d2e7e8ba3df8 |
| 15 | Settings | 9595423fc1644b04a3b4f447f4dea1ca |
| 16 | Appointments | 0b4f255b798a49b586fcc817dccc2528 |

## Using the Assets

After downloading:

1. **Extract Design System** from screen #1 (Design System)
   - Colors → `app/src/main/java/com/health2u/ui/theme/Color.kt`
   - Typography → `app/src/main/java/com/health2u/ui/theme/Type.kt`
   - Spacing → `app/src/main/java/com/health2u/ui/theme/Dimensions.kt`

2. **Reference screens** during implementation
   - Use images as visual reference
   - Extract spacing and layout from specs
   - Match colors exactly from design system

## Notes

- The download script is a template and may need adjustments based on the actual Stitch SDK API
- If you encounter issues, check the Stitch SDK documentation: https://developers.google.com/stitch
- All assets are for development use only and should not be committed to version control if they contain proprietary designs
