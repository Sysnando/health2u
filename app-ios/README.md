# Health2u iOS

Native iOS client for Health2u, at feature parity with `app-android`.

## Prerequisites

- macOS with Xcode 15+ or Swift 5.10+ Command Line Tools
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for generating .xcodeproj)

## Build

### Partial CLI build (no Xcode required)

```bash
cd app-ios
swift build
```

### Full build with Xcode

```bash
cd app-ios
xcodegen generate
xcodebuild -project Health2u.xcodeproj -scheme Health2u \
  -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### Run tests

```bash
xcodebuild test -project Health2u.xcodeproj -scheme Health2u \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

See [docs/IOS_IMPLEMENTATION_PLAN.md](../docs/IOS_IMPLEMENTATION_PLAN.md) for the full specification.
