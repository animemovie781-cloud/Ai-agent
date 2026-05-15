# Jarvis AI Assistant - Production Android App

A powerful AI-driven Android assistant that can control your phone autonomously using voice and text commands.

## 🚀 Features

### Core Capabilities
- **Voice Control** - Wake word activation ("Hey Jarvis"), continuous listening, speech-to-text
- **Text Commands** - Natural language understanding, multi-step task execution
- **Screen Automation** - Accessibility-based UI control, gesture execution, app navigation
- **Multi-Provider AI** - OpenAI, Gemini, Claude, Groq, OpenRouter, Ollama support
- **Screen Reading** - OCR text extraction, UI element detection, visual understanding
- **Floating Overlay** - Always-available AI assistant bubble, drag & drop
- **Browser Automation** - Web page interaction, form filling, navigation
- **Smart Planning** - Task decomposition, workflow planning, autonomous execution
- **Memory System** - Conversation history, user preferences, app state learning
- **Notification Reader** - Read & respond to notifications automatically
- **Gesture Execution** - Tap, swipe, pinch, long-press, multi-touch gestures

### Advanced Features
- **Autonomous Workflow Engine** - Observe → Think → Act loop for continuous automation
- **AI Router** - Smart provider selection, automatic failover, capability-based routing
- **Error Recovery** - Self-healing selectors, retry logic, fallback strategies
- **Local AI** - Support for on-device Ollama inference
- **Streaming Responses** - Real-time AI output with typing indicators
- **Secure Storage** - Android Keystore, encrypted shared preferences
- **Privacy Mode** - Optional on-device processing only

## 🏗 Architecture

### Clean Architecture Layers
```
app/                          # Presentation Layer (Compose UI)
├── MainActivity.kt           # Entry point, navigation
├── MainChatActivity.kt       # Chat interface
├── PermissionActivity.kt     # Permission handling

core/
├── common/                   # Shared utilities, extensions, security
├── domain/                   # Business logic entities & use cases
│   └── model/               # All domain models
│   └── repository/          # Repository interfaces
│   └── usecase/             # Interactors
├── data/                     # Data layer (Room, API clients)
│   └── local/               # Database & DAOs
│   └── remote/              # Retrofit API services
└── ui/                      # Shared Compose UI components

feature/
├── ai/                      # AI provider system & router
│   └── providers/           # OpenAI, Gemini, Claude, Groq, Ollama
│   └── router/              # Smart AI routing
├── voice/                   # Speech recognition & TTS
├── accessibility/           # AccessibilityService implementation
├── overlay/                 # Floating assistant bubble
├── ocr/                     # ML Kit text recognition
├── screen/                  # Screen capture & analysis
├── automation/              # Task execution & workflow engine
├── notification/            # Notification listener
├── gesture/                 # Gesture execution
├── planner/                 # Task planning & decomposition
├── memory/                  # Memory & context system
└── browser/                 # Web automation
```

### Data Flow
```
User Input (Voice/Text)
    ↓
AI Router (Select best provider)
    ↓
Task Planner (Convert to actions)
    ↓
Workflow Engine (Observe-Think-Act loop)
    ↓
Accessibility Service (UI interactions)
    ↓
Screen Capture & OCR (Verify state)
    ↓
Memory System (Store context)
    ↓
Feedback & Results
```

## 🛠 Tech Stack

### Android
- **Minimum SDK**: 26 (Android 8.0)
- **Target SDK**: 34 (Android 14)
- **Language**: Kotlin 100%
- **UI**: Jetpack Compose + Material 3
- **Architecture**: MVVM + Clean Architecture
- **Async**: Kotlin Coroutines + Flow

### Dependencies
- **DI**: Dagger Hilt
- **Database**: Room (SQLite)
- **Networking**: Retrofit + OkHttp
- **AI**: Multiple provider SDKs (OpenAI, Anthropic, Google)
- **OCR**: Google ML Kit Text Recognition
- **Screen Capture**: MediaProjection API
- **Automation**: AccessibilityService + Gesture API
- **Voice**: Android SpeechRecognizer + TextToSpeech
- **Browser**: Chrome Custom Tabs + JSoup

## 📱 Modules

### `app` - Main Application
- MainActivity - Launcher with bottom navigation
- ChatScreen - Messaging UI with glassmorphism
- PermissionActivity - Runtime permission handling
- Hilt Application class

### `core.common` - Utilities
- PreferencesManager - Shared preferences wrapper
- SecurityManager - Android Keystore, encrypted storage
- PermissionManager - Runtime permission checking

### `core.domain` - Business Logic
- **Models**: User, Task, Message, Action, UIElement, etc.
- **Repositories**: Conversation, Task, Memory, Voice, Automation, Screen, etc.
- **Use Cases**: GetConversations, SendAIRequest, PlanTask, etc.

### `core.data` - Repositories
- **Local**: Room Database with entities & DAOs
- **Remote**: Retrofit API services (OpenAI, Gemini, Claude, Groq, etc.)
- **Implementations**: Repository implementations

### `feature.ai` - AI System
- **OpenAIProvider** - GPT-4, GPT-3.5-turbo
- **GeminiProvider** - Vision & text models
- **ClaudeProvider** - Claude 3 family
- **GroqProvider** - Ultra-fast Llama inference
- **OllamaProvider** - Local LLM support
- **AIRouter** - Smart provider selection & failover

### `feature.voice` - Voice System
- SpeechRecognizer - Voice command detection
- TextToSpeech - AI spoken responses
- WakeWordDetector - "Hey Jarvis" trigger
- VoiceDetectionService - Background voice service

### `feature.accessibility` - Automation Core
- JarvisAccessibilityService - Root automation service
- UI element detection & interaction
- Gesture dispatch
- App navigation

### `feature.overlay` - Floating UI
- FloatingOverlayService - System overlay
- Chat head interface
- Voice controls
- Expandable chat view

### `feature.ocr` - Screen Reading
- ML Kit text extraction
- Image processing pipeline
- Text element detection

### `feature.automation` - Task Execution
- TaskExecutor - Step execution engine
- ActionExecutor - Individual action handling
- WorkflowEngine - Autonomous Observe-Think-Act loop
- ValidationService - Action verification

### `feature.notification` - Notifications
- NotificationListenerService
- Smart notification processing
- Auto-reply suggestions

### `feature.gesture` - Gestures
- GestureExecutor - Tap, swipe, pinch, etc.
- Gesture composition & animation

### `feature.planner` - Planning
- TaskPlanner - Natural language to actions
- Task decomposition heuristics
- AI-assisted planning

### `feature.memory` - Memory
- MemorySystem - Conversation & context storage
- User preference learning
- App state tracking

### `feature.browser` - Web Automation
- BrowserAutomation - Chrome Custom Tabs
- Web scraping with JSoup
- Form interaction

## 🔧 Configuration

### AI Provider Setup

Edit `app/src/main/res/values/strings.xml` or in Settings:

```kotlin
// OpenAI
apiKey = "sk-..."
provider = "openai"
model = "gpt-4-turbo"

// Gemini
apiKey = "AI..."
provider = "gemini"
model = "gemini-pro-vision"

// Claude
apiKey = "sk-ant..."
provider = "claude"
model = "claude-3-sonnet"
```

### Permissions (AndroidManifest.xml)

Required:
- `RECORD_AUDIO` - Voice commands
- `CAMERA` - Screenshots
- `SYSTEM_ALERT_WINDOW` - Overlay display
- `BIND_ACCESSIBILITY_SERVICE` - Automation control
- `BIND_NOTIFICATION_LISTENER_SERVICE` - Notification reading
- `FOREGROUND_SERVICE` - Background operation

## 🎨 UI Design

### Color Palette
- **Primary**: #00D4FF (Cyan)
- **Secondary**: #7C4DFF (Purple)
- **Success**: #00FF88 (Green)
- **Error**: #FF6B6B (Red)
- **Background**: #0A0A1F (Deep Blue)

### Design Principles
- Glassmorphism cards with background blur
- Gradient accents and borders
- Rounded corners (16dp default)
- Subtle shadows & elevation
- Dark mode only

## 🔐 Security

- **API Keys**: Stored in EncryptedSharedPreferences
- **Master Key**: Android Keystore AES256_GCM
- **Biometric**: Optional authentication for access
- **Secure Comm**: HTTPS/TLS for all API calls
- **Privacy Mode**: All processing on-device only

## 🚦 Workflow Engine

The autonomous engine uses a 3-step loop:

1. **Observe**: Screenshot + Accessibility tree + OCR
2. **Think**: AI reasoning → decide next action
3. **Act**: Execute action via AccessibilityService

Example: "Open YouTube and search cat videos"
```
Iteration 1: Observe → Find YouTube icon → TAP
Iteration 2: Observe → Find search field → TAP
Iteration 3: Observe → Type "cat videos" → TYPE
Iteration 4: Observe → Find search button → TAP
```

## 🧠 AI Provider Selection

AIRouter automatically selects best provider based on:
- Task type (vision → Gemini, code → GPT, long context → Claude, fast → Groq)
- Past failures (avoid recently failed providers)
- User preferences
- Cost efficiency

## 📋 Planned Tasks

Tasks are structured JSON actions:
```json
{
  "description": "Open YouTube",
  "steps": [
    {
      "action": { "type": "OPEN_APP", "parameters": { "packageName": "com.google.android.youtube" } }
    }
  ]
}
```

## 🔄 Memory System

Stores:
- Conversation history
- App usage patterns
- Successful actions
- User preferences
- Current task context

## 🧪 Testing

Run tests:
```bash
./gradlew test
./gradlew connectedAndroidTest
```

## 🚀 Building

Debug build:
```bash
./gradlew assembleDebug
```

Release build:
```bash
./gradlew assembleRelease
```

## 🚀 Installation

1. Open in Android Studio
2. Sync Gradle
3. Add OpenAI/Gemini API keys in Settings
4. Grant permissions on first launch
5. Enable Accessibility & Overlay permissions manually
6. Start chatting!

## 📚 Resources

- [Android AccessibilityService](https://developer.android.com/reference/android/accessibilityservice/AccessibilityService)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
- [ML Kit Text Recognition](https://developers.google.com/ml-kit/vision/text-recognition)
- [Android Permission Best Practices](https://developer.android.com/guide/topics/permissions/overview)

## 📄 License

MIT License - See LICENSE file

## 🙋 Support

For issues and feature requests, please open a GitHub issue.

---

**Jarvis AI** - Your autonomous Android assistant.
