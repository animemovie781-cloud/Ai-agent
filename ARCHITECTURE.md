# Jarvis AI Assistant - Master Architecture Document

## Executive Summary

Jarvis is a production-grade Android AI assistant built in Kotlin using Clean Architecture. It's designed as an autonomous AI agent capable of controlling an Android phone through voice and text commands, with support for multiple AI providers, screen automation, and a floating overlay interface.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  (Jetpack Compose UI, MainActivity, FloatingOverlay)       │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  (Use Cases, Entities, Repository Interfaces)               │
│    • GetConversationsUseCase                                │
│    • SendAIRequestUseCase                                   │
│    • PlanTaskUseCase                                        │
│    • ExecuteTaskUseCase                                     │
└─────────────────────────┬───────────────────────────────────┘
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                     DATA LAYER                               │
│  • Room Database (conversations, tasks, memory)            │
│  • Retrofit API (OpenAI, Gemini, Claude, Groq, Ollama)     │
│  • Repository Implementations                              │
└─────────────────────────────────────────────────────────────┘
```

## Module Breakdown

### 1. AI Provider System (`feature.ai`)

#### Architecture: Factory Pattern + Strategy Pattern

**Base Interface (`AIProvider.kt`)**
```kotlin
interface AIProvider {
    val id: String
    val name: String
    val capabilities: Set<AICapability>
    suspend fun sendRequest(request: AIRequest): AIResponse
    fun streamRequest(request: AIRequest): Flow<AIResponse>
}
```

**Implementations:**
- `OpenAIProvider` - GPT-4, GPT-3.5-turbo, Vision
- `GeminiProvider` - Gemini Pro, Vision models
- `ClaudeProvider` - Claude 3 family (Opus, Sonnet, Haiku)
- `GroqProvider` - Llama 3, Mixtral (ultra-fast)
- `OpenRouterProvider` - Aggregates multiple providers
- `OllamaProvider` - Local LLM support

**AI Router (`AIRouter.kt`)**
- Analyzes message context to determine requirements
- Scores providers based on capabilities & reliability
- Automatic failover on provider errors
- Smart routing: Vision→Gemini, Code→GPT, Reasoning→Claude, Fast→Groq

**Data Models:**
- `AIRequest` - Model, messages, temp, maxTokens, tools, image
- `AIResponse` - Content, toolCalls, usage, finishReason
- `AITool` - Function calling for automation actions

### 2. Voice System (`feature.voice`)

**Components:**
- `VoiceDetectionService` - Background service for always-on listening
- `SpeechRecognizer` - Android's STT with continuous mode
- `TextToSpeech` - AI responses spoken aloud
- `WakeWordDetector` - Keyword spotting ("Hey Jarvis")

**Flow:**
```
Wake Word Detected → Start STT → Partial results → Full transcription → AI Processing → TTS response
```

**Features:**
- Continuous listening with energy-based VAD
- Partial result streaming
- Configurable wake words
- Low-power background operation

### 3. Accessibility Automation (`feature.accessibility`)

**`JarvisAccessibilityService`** - Core automation engine

**Capabilities:**
- Parse full UI hierarchy into `UIElement` tree
- `performAction()` - Click, long-press, scroll
- `dispatchGesture()` - Custom gestures (swipe, pinch, multi-touch)
- `typeText()` - Input into focused fields
- `findElementByText/ID()` - UI element search

**UI Parsing:**
```kotlin
fun parseNodeRecursive(
    node: AccessibilityNodeInfo,
    parent: UIElement?
): UIElement {
    // Recursively extract bounds, text, descriptions
    // Build element tree with parent references
    // Categorize as text, clickable, input
}
```

**Actions Implemented:**
- TAP, SWIPE, SCROLL, TYPE
- OPEN_APP (via Intent)
- PRESS_BACK/HOME/RECENTS
- WAIT, FIND_ELEMENT, CLICK_TEXT/ID/DESCRIPTION

### 4. Screen Understanding (`feature.ocr` + `feature.screen`)

**Screen Capture (`ScreenCaptureManager`):**
- `MediaProjection` API for screen recording
- `VirtualDisplay` + `ImageReader` for real-time frames
- Bitmap extraction & cropping

**Text Extraction (`OCRProcessor`):**
- Google ML Kit Text Recognition
- `InputImage` from bitmap
- Returns `TextBlock` → `TextLine` hierarchy
- Bounding boxes for each text element

**Screen Analyzer (`ScreenAnalyzer`):**
- Combines Accessibility tree + OCR output
- Merges element positions with detected text
- Creates unified `ScreenContent` model

### 5. Task Planning (`feature.planner`)

**`TaskPlanner`** - Natural language → structured tasks

Input: "Open YouTube and search anime trailers"

Process:
1. AI-powered planning with prompt engineering
2. Parse JSON response → `Task` with `TaskStep`s

**Decomposition Heuristics (fallback):**
```
Command Pattern → Steps:
"open X"       → OPEN_APP(package=X)
"search Y"     → TAP(search), TYPE(Y), PRESS_ENTER
"scroll up"    → SWIPE(up)
"tap button"   → FIND_ELEMENT, TAP
```

**Output:**
```kotlin
Task(
    description = "Open YouTube and search anime trailers",
    steps = [
        TaskStep(Action(OPEN_APP, mapOf("packageName" to "com.google.android.youtube"))),
        TaskStep(Action(FIND_ELEMENT, mapOf("byText" to "search"))),
        TaskStep(Action(TAP)),
        TaskStep(Action(TYPE, mapOf("text" to "anime trailers"))),
        TaskStep(Action(PRESS_ENTER))
    ]
)
```

### 6. Task Execution (`feature.automation`)

**`TaskExecutor`** - Orchestrates step execution

Process per step:
1. Execute via `ActionExecutor`
2. Validate with `ValidationService`
3. Retry (up to 3 times) on failure
4. Store result in memory

**`ActionExecutor`** - Atomic action execution

Each action type:
```kotlin
TAP: Find element by ID/text → GestureExecutor.tap(x, y)
SWIPE: GestureExecutor.swipe(x1,y1,x2,y2,duration)
TYPE: AccessibilityNodeInfo.performAction(ACTION_SET_TEXT)
SCROLL: Swipe gesture in direction
```

**Validation Rules:**
- UI_ELEMENT_VISIBLE - Element appears after action
- TEXT_CONTAINS - Screen has expected text
- SCREEN_CHANGED - Hash comparison
- APP_CHANGED - Package name check

### 7. Autonomous Workflow Engine

**`WorkflowEngine`** - Observe → Think → Act Loop

```
┌──────────────────────────────────────────┐
│  1. OBSERVE                              │
│     • Capture screenshot                 │
│     • Parse Accessibility tree          │
│     • Run OCR                            │
│     • Retrieve relevant memory          │
└───────────────┬──────────────────────────┘
                │
┌───────────────▼──────────────────────────┐
│  2. THINK (AI Reasoning)                │
│     • Current state + Goal              │
│     • Previous actions                  │
│     • AI predicts next action           │
└───────────────┬──────────────────────────┘
                │
┌───────────────▼──────────────────────────┐
│  3. ACT                                 │
│     • Execute action via Accessibility  │
│     • Wait for result                   │
│     • Validate outcome                  │
└───────────────┬──────────────────────────┘
                │
        ┌───────┴───────┐
        │   Loop again  │ (if not achieved)
        └───────────────┘
```

**Features:**
- Stuck detection (repeating same action)
- Recovery strategies (back button, restart)
- Confidence scoring
- Step-by-step result logging
- Max iteration limits

### 8. Memory System (`feature.memory`)

**`MemorySystem`** - Long-term & short-term storage

**Storage Types:**
- **Key-Value** - Simple retrieval
- **Contextual** - Tagged by context string
- **Timeline** - Time-ordered retrieval
- **Importance-based** - High/Medium/Low priority

**Usage Examples:**
```kotlin
store("last_app", "com.whatsapp", "app_state")
store("user_pref_theme", "dark", "preferences", importance=HIGH)
getByContext("navigation")
getRecent(limit=10)
```

**Database:** Room with `MemoryEntity` tracking key, value, context, timestamp, expiry, importance

### 9. Floating Overlay (`feature.overlay`)

**`FloatingOverlayService`** - System alert window

**Features:**
- Draggable bubble (touch listener)
- Tap to expand → Compose chat UI
- Expandable conversation view
- Voice input toggle
- Glassmorphism effects
- Auto-hide option

**Implementation:**
- `WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY`
- `ComposeView` for modern UI
- Touch gesture handling for drag & drop
- Minimize to floating bubble

### 10. Notification Reader (`feature.notification`)

**`NotificationListenerService`** - System integration

**Capabilities:**
- Listen to all notification posts/removes
- Extract title, text, actions
- Store in memory
- AI-powered auto-reply suggestions
- Dismiss & reply programmatically

**AI Integration:**
```
Notification received → AI analyzes → Suggests reply or action
```

### 11. Browser Automation (`feature.browser`)

**`BrowserAutomation`** - Chrome Custom Tabs + JSoup

**Features:**
- Navigate to URLs
- Extract page content (JSoup parsing)
- Search for text/elements
- Click links
- Fill & submit forms
- JavaScript execution (via WebView)
- Scroll control

**Workflow:**
```
User: "Search Google for weather forecast"
→ Navigate google.com
→ Find search box → Type "weather forecast"
→ Press Enter
→ Extract results
```

## Data Models

### Core Entities

**User**
```kotlin
data class User(
    val id: String,
    val name: String,
    val preferences: UserPreferences
)
```

**Task**
```kotlin
data class Task(
    val id: String,
    val description: String,
    val steps: List<TaskStep>,
    val currentStep: Int,
    val status: TaskStatus
)
```

**Action**
```kotlin
data class Action(
    val type: ActionType,
    val parameters: Map<String, Any>,
    val timeout: Long,
    val retry: Boolean,
    val validation: ValidationRule?
)
```

**Message**
```kotlin
data class Message(
    val id: String,
    val role: MessageRole,  // USER, ASSISTANT, SYSTEM, TOOL
    val content: String,
    val toolCalls: List<ToolCall>,
    val attachments: List<Attachment>
)
```

**UIElement**
```kotlin
data class UIElement(
    val id: String,
    val resourceId: String?,
    val className: String,
    val text: String?,
    val bounds: Rect?,
    val clickable: Boolean,
    val focusable: Boolean,
    val children: List<UIElement>
)
```

## AI Provider Integration

### OpenAI (GPT-4, GPT-3.5)

**Endpoint:** `https://api.openai.com/v1/chat/completions`

**Features:**
- Chat completion
- Vision API (image_input)
- Function calling
- Streaming (SSE)
- DALL-E image generation

### Google Gemini

**Endpoint:** `https://generativelanguage.googleapis.com/v1/models/{model}:generateContent`

**Features:**
- Native vision support (multimodal)
- High context window (1M tokens)
- Function calling
- Fast inference

### Anthropic Claude

**Endpoint:** `https://api.anthropic.com/v1/messages`

**Features:**
- Constitutional AI (safe)
- 200K context window
- Strong reasoning & coding
- Tool use

### Groq (Llama 3)

**Endpoint:** `https://api.groq.com/openai/v1/chat/completions`

**Features:**
- Extremely fast (500+ tok/s)
- Meta Llama 3 models
- OpenAI-compatible API

### Ollama (Local)

**Endpoint:** `http://localhost:11434` (configurable)

**Features:**
- Fully on-device (privacy)
- No API costs
- Custom model support

## Implementation Details

### Permissions

**Required (AndroidManifest.xml):**
- `RECORD_AUDIO` - Voice recognition
- `CAMERA` - Screenshots via MediaProjection
- `READ_MEDIA_IMAGES` - Access to captured images
- `SYSTEM_ALERT_WINDOW` - Overlay permission (special)
- `BIND_ACCESSIBILITY_SERVICE` - Automation (special)
- `BIND_NOTIFICATION_LISTENER_SERVICE` - Notifications (special)
- `FOREGROUND_SERVICE` - Background operation

**Runtime:** Requested via PermissionActivity

### Services

**Background Services:**
1. `VoiceDetectionService` - Foreground, voice listening
2. `JarvisAccessibilityService` - Accessibility automation
3. `FloatingOverlayService` - Overlay UI
4. `NotificationListener` - Notification monitoring

**Lifecycle:**
- Start on boot (BOOT_COMPLETED receiver)
- Restart on crash
- Foreground service with notification

### Security

**API Keys:**
- Stored in `EncryptedSharedPreferences`
- Master key from Android Keystore
- AES256_GCM encryption

**Biometric:**
- Optional auth for API key access
- `BiometricManager` integration

**Privacy Mode:**
- Disable cloud AI
- Only on-device models (Ollama)
- No data logging

### Performance

**Optimizations:**
- Coroutines for async operations
- Flow for reactive streams
- LazyColumn for chat history
- Image downsampling for OCR
- Request deduplication
- Connection pooling (OkHttp)

**Memory:**
- Bitmap recycling
- LRU cache for screenshots
- Bounded message history

## Testing Strategy

**Unit Tests:**
- Use cases (planner, router, memory)
- Repository implementations
- AI provider parsing

**Integration Tests:**
- Room database operations
- Retrofit API calls
- ActionExecutor with mock accessibility

**UI Tests:**
- Compose UI components
- Navigation flows
- Theme verification

## Known Limitations & Future Work

1. **Multi-touch gestures** - Only single-finger gestures implemented
2. **Discord/Telegram** - Specific app automation needs custom handlers
3. **Biometric auth** - Optional, not enforced
4. **Offline AI** - Only Ollama support currently
5. **Video analysis** - OCR is frame-based, no video understanding
6. **App-specific UI** - Generic selectors may fail on custom UIs

## Development Guidelines

**Code Style:**
- Kotlin official style guide
- 4-space indentation
- Max line length 120
- PascalCase for classes, camelCase for functions/vars
- Extension functions for cross-cutting concerns

**Commit Messages:**
- `feat:` New feature
- `fix:` Bug fix
- `refactor:` Code restructuring
- `docs:` Documentation
- `test:` Add tests

**Architecture Rules:**
- Domain layer has no Android dependencies
- Data layer handles all persistence
- Presentation layer is UI-only
- Feature modules should be independent

## Build Configuration

**Module Dependencies:**
```
app → core.* → feature.*
feature.ai → feature.planner → feature.automation → feature.accessibility
```

**Gradle Setup:**
- Kotlin DSL (`.kts`) build files
- Version catalog for dependencies
- Kapt for annotation processing
- Compose compiler plugin

## Deployment

**Release Checklist:**
1. Update versionCode & versionName
2. Sign with release keystore
3. ProGuard/R8 optimizations enabled
4. Test on multiple API levels (26, 29, 33)
5. Verify permissions flow
6. Check for sensitive data leaks

**Distribution:**
- Direct APK download (GitHub Releases)
- Google Play Store (if compliant)
- Internal testing track

## Contributing

1. Fork the repository
2. Create feature branch
3. Ensure tests pass
4. Submit PR with description

## License

MIT License - Free for personal & commercial use

---

Created with ❤️ by the Jarvis AI Team
