# Health2U

Health2U (My Health Hub) is a health management platform that helps users track medical records, organize exams, manage appointments, and gain insights into their health data. The project is structured as a monorepo with a Node.js backend and native mobile clients.

## Packages

| Directory | Description |
|---|---|
| `admin-service/` | Node.js backend (Express). Serves the REST API. |
| `app-android/` | Native Android app (Kotlin + Jetpack Compose). |
| `app-ios/` | iOS app (placeholder; not yet implemented). |
| `design-assets/` | Shared design assets from Stitch. |
| `docs/` | Architecture docs, implementation plan, design system notes. |

## Quickstart

### Run the backend

```bash
cd admin-service && npm install && npm run dev
```

The server starts on port 3000.

### Run the Android app on an emulator

Open `app-android/` in Android Studio, or:

```bash
cd app-android && ./gradlew installDebug
```

The debug build hits `http://10.0.2.2:3000` which is the emulator's loopback to host localhost.

### Default credentials

- Email: `sarah@example.com`
- Password: `password123`

## Documentation

- [CLAUDE.md](docs/CLAUDE.md) -- project conventions and architecture overview for Claude Code
- [IMPLEMENTATION_PLAN.md](docs/IMPLEMENTATION_PLAN.md) -- 12-week phased development plan
- [CONTRACTS.md](docs/CONTRACTS.md) -- integration contracts between agents and layers

## Repository layout

```
health2u/
├── admin-service/          # Express backend (Node.js)
│   ├── src/
│   │   ├── routes/
│   │   ├── middleware/
│   │   └── data/seed.js
│   ├── package.json
│   └── README.md
├── app-android/            # Android app (Kotlin + Compose)
│   ├── app/
│   ├── gradle/
│   ├── build.gradle.kts
│   └── settings.gradle.kts
├── app-ios/                # iOS placeholder
│   └── README.md
├── design-assets/          # Stitch design downloads
├── docs/                   # Architecture & planning docs
│   ├── CLAUDE.md
│   ├── CONTRACTS.md
│   ├── IMPLEMENTATION_PLAN.md
│   └── ...
├── .gitignore
├── PLAN.md
└── README.md
```
