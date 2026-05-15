# Quick Start Guide

## Getting Started with Jarvis AI

### Prerequisites
- Android Studio Hedgehog (2023.1.1) or later
- Android SDK API 26-34
- Java 17
- Gradle 8.2+

### 1. Open Project
```
File → Open → Select the project folder
```

### 2. Initial Gradle Sync
Android Studio will automatically sync Gradle. Wait for completion.

### 3. Add API Keys

Open `app/src/main/java/com/jarvis/ai/presentation/MainViewModel.kt`

Or add to SharedPreferences programmatically:
```kotlin
val secureStorage = SecureStorage(context)
secureStorage.storeApiKey("openai", "sk-your-api-key")
secureStorage.storeApiKey("gemini", "your-api-key")
```

Alternatively, configure in app Settings screen after first launch.

### 4. Grant Permissions

First launch will show permission screen:

1. **Overlay Permission** - Tap to open system settings → Enable "Allow overlay"
2. **Accessibility** - Tap to open settings → Enable "Jarvis Accessibility Service"
3. **Microphone** - Grant when prompted
4. **Camera** - Grant for screenshots
5. **Notifications** - Grant to read notifications

### 5. Configure AI Provider

Open app → Settings → Select AI Provider:
- OpenAI (GPT-4 recommended)
- Gemini (best for vision)
- Claude (best for reasoning)
- Groq (fastest)
- Ollama (local, no API key)

Enter your API key.

### 6. Start Using Jarvis

**Chat Interface:**
- Type commands: "Open YouTube"
- Tap mic for voice: "What's on my screen?"
- Send messages: "Read my notifications"

**Floating Overlay:**
- Drag the bubble around
- Tap to expand chat
- Voice toggle button

**Voice Commands:**
- "Hey Jarvis" (wake word) → start listening
- "Open [app name]"
- "Search for [query]"
- "Scroll down/up"
- "Tap [button name]"
- "Type [text]"
- "Go back/Home"

### 7. Test Features

**Basic Automation:**
```
"Open Settings"
"Scroll down"
"Tap WiFi"
```

**Complex Task:**
```
"Open Chrome and search for weather in New York"
```

**Vision (if using Gemini/GPT-4V):**
```
"What's on my screen?"
```

### 8. Troubleshooting

**Overlay not showing:**
- Settings → Apps → Special access → Draw over other apps → Enable

**Automation not working:**
- Settings → Accessibility → Jarvis Accessibility → Enable

**Voice not activating:**
- Check microphone permission
- Check if VoiceDetectionService is running (Settings → Apps → Running)

**AI not responding:**
- Verify API key in Settings
- Check internet connection
- Try different provider

**App crashes on startup:**
- Ensure all permissions granted
- Check logcat for errors
- Reinstall app

### 9. Development

**Build variants:**
- Debug: `./gradlew assembleDebug`
- Release: `./gradlew assembleRelease`

**Run on device:**
```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

**Run tests:**
```bash
./gradlew test
./gradlew connectedAndroidTest
```

**Code style:**
- Uses ktlint + detekt (run via Gradle)

### 10. Key Features to Try

1. **Multi-step tasks:** "Book a ride to airport"
2. **Screen analysis:** "What apps are installed?"
3. **Notification reading:** "Read my notifications"
4. **Voice commands:** Use wake word
5. **Floating chat:** Drag bubble, ask questions
6. **Web automation:** "Search for news"
7. **App switching:** "Open WhatsApp"
8. **Text input:** "Type hello world"
9. **Gesture control:** "Swipe up"
10. **Memory:** "Remember I like dark mode"

## Project Structure Quick Reference

```
jarvis-ai/
├── app/                          # Main app
│   └── src/main/
│       ├── AndroidManifest.xml   # Permissions & services
│       ├── java/com/jarvis/ai/presentation/
│       │   ├── MainActivity.kt   # Navigation host
│       │   └── MainChatActivity.kt  # Chat UI
│       └── res/                 # Resources
├── core/
│   ├── common/                  # Utils, security
│   ├── domain/                  # Business logic
│   │   └── model/              # All data classes
│   ├── data/                    # Database, APIs
│   └── ui/                     # Shared UI
├── feature/
│   ├── ai/                     # AI providers & router
│   ├── voice/                  # Speech & TTS
│   ├── accessibility/          # Automation service
│   ├── overlay/                # Floating bubble
│   ├── ocr/                    # Text recognition
│   ├── screen/                 # Screen capture
│   ├── automation/             # Task executor
│   ├── notification/           # Notification reader
│   ├── gesture/                # Gestures
│   ├── planner/                # Task planning
│   ├── memory/                 # Memory system
│   └── browser/                # Web automation
└── docs/                      # Documentation
```

## Next Steps

1. Customize wake word in settings
2. Set up default AI provider
3. Create custom workflows
4. Explore automation templates
5. Enable privacy mode for sensitive data

## Support

- Issues: GitHub repository
- Documentation: See `ARCHITECTURE.md`
- Contributing: See contributing guidelines

---

**Jarvis AI** - Let AI control your device! 🚀
