# Kilo Agent Configuration

## Kilo Settings

# How Kilo should behave when working on this project

## Preferred Commands

### Build & Test
```bash
./gradlew assembleDebug
./gradlew test
./gradlew connectedAndroidTest
./gradlew assembleRelease
```

### Code Quality
```bash
./gradlew ktlintFormat
./gradlew detekt
```

### Installation
```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

## Worktree Structure

```
/cache/kilo/jarvis-ai/
├── app/                    # Main app module
├── core/                   # Shared core modules
├── feature/               # Feature modules
├── gradle/               # Gradle wrapper
└── README.md
```

## Memory Instructions

### Critical Files
- `core/domain/src/main/java/com/jarvis/ai/domain/model/Entities.kt` - Domain models
- `feature/ai/src/main/java/com/jarvis/ai/feature/ai/providers/` - AI providers
- `feature/accessibility/src/main/java/com/jarvis/ai/feature/accessibility/JarvisAccessibilityService.kt` - Automation
- `feature/overlay/src/main/java/com/jarvis/ai/feature/overlay/FloatingOverlayService.kt` - Overlay
- `app/src/main/AndroidManifest.xml` - Permissions & services

### Architecture Notes
- Clean Architecture with domain, data, presentation layers
- Feature modules are independent & self-contained
- Hilt for dependency injection
- Room for local persistence
- Compose for UI (Material 3, dark theme)

## Agents Registry

This project contains:
- `jarvis-ai` - Full Android AI assistant implementation

No additional agents required.
