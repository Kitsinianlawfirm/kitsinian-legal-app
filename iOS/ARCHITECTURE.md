# ClaimIt iOS Architecture Design Document

**Version:** 2.0
**Date:** February 2026
**Status:** Design Recommendations

---

## 1. Executive Summary

This document outlines the architectural design for the ClaimIt iOS application, identifying current patterns, concerns, and recommended improvements based on 2026 iOS best practices.

---

## 2. Current Architecture Overview

### 2.1 Pattern: MVVM (Model-View-ViewModel)

```
┌─────────────────────────────────────────────────────────────────┐
│                        Application Layer                         │
├─────────────────────────────────────────────────────────────────┤
│  KitsinianLegalApp.swift                                        │
│  └── AppState (@EnvironmentObject)                              │
│      ├── hasCompletedOnboarding                                 │
│      ├── currentLead                                            │
│      ├── selectedPracticeArea                                   │
│      └── selectedIncidentType                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Presentation Layer                          │
├─────────────────────────────────────────────────────────────────┤
│  ContentView.swift                                              │
│  └── Navigation Controller (TabView / NavigationSplitView)      │
│      ├── HomeView                                               │
│      ├── QuizStartView → QuizFlowView                          │
│      ├── ResourceLibraryView → ResourceDetailView              │
│      ├── AccidentModeTabView → AccidentModeFlowView            │
│      └── ContactView → LeadFormView                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       ViewModel Layer                            │
├─────────────────────────────────────────────────────────────────┤
│  QuizViewModel (embedded in QuizFlowView.swift)                 │
│  LeadFormViewModel (embedded in LeadFormView.swift)             │
│  AccidentModeManager (Services/AccidentMode/)                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        Model Layer                               │
├─────────────────────────────────────────────────────────────────┤
│  Lead.swift         - User submission data                      │
│  PracticeArea.swift - 15 practice areas with FAQs               │
│  Quiz.swift         - Adaptive quiz flow definitions            │
│  Resource.swift     - 7 legal resource guides                   │
│  AccidentReport.swift - Emergency evidence data                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Services Layer                             │
├─────────────────────────────────────────────────────────────────┤
│  APIService.swift - Backend communication                       │
│  └── submitLead() async throws                                  │
│  └── Future: fetchResources(), uploadEvidence()                 │
└─────────────────────────────────────────────────────────────────┘
```

### 2.2 Directory Structure

```
KitsinianLegal/
├── App/
│   ├── KitsinianLegalApp.swift    # Entry + AppState
│   ├── ContentView.swift          # Root navigation
│   └── Theme.swift                # Design system
├── Models/
│   ├── Lead.swift
│   ├── PracticeArea.swift
│   ├── Quiz.swift
│   ├── Resource.swift
│   └── AccidentReport.swift
├── Views/
│   ├── HomeView.swift
│   ├── Quiz/
│   ├── PracticeAreas/
│   ├── Resources/
│   ├── Contact/
│   ├── AccidentMode/
│   └── Onboarding/
├── Services/
│   ├── APIService.swift
│   └── AccidentMode/
├── ViewModels/                    # EMPTY - VMs inline
├── Extensions/                    # EMPTY
└── Assets.xcassets/
```

---

## 3. Data Flow Patterns

### 3.1 Quiz Flow (Unidirectional)

```
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│ User Taps    │────▶│ QuizOptionButton│────▶│ QuizViewModel    │
│ Option       │     │ action()        │     │ selectOption()   │
└──────────────┘     └─────────────────┘     └──────────────────┘
                                                      │
                                                      ▼
┌──────────────┐     ┌─────────────────┐     ┌──────────────────┐
│ View         │◀────│ @Published      │◀────│ Update state:    │
│ Re-renders   │     │ currentQuestion │     │ - questionId     │
└──────────────┘     └─────────────────┘     │ - progress       │
                                             │ - isComplete     │
                                             └──────────────────┘
```

### 3.2 Lead Submission Flow

```
┌────────────────────────────────────────────────────────────────┐
│                      LeadFormView                               │
├────────────────────────────────────────────────────────────────┤
│  @StateObject viewModel = LeadFormViewModel()                  │
│                                                                 │
│  Form Fields ──▶ viewModel.lead (binding)                      │
│  Submit Button ──▶ viewModel.submitLead()                      │
│                          │                                      │
│                          ▼                                      │
│                 ┌─────────────────────┐                        │
│                 │ isSubmitting = true │                        │
│                 └─────────────────────┘                        │
│                          │                                      │
│                          ▼                                      │
│         ┌────────────────────────────────────┐                 │
│         │ APIService.shared.submitLead(lead) │                 │
│         └────────────────────────────────────┘                 │
│                          │                                      │
│              ┌───────────┴───────────┐                         │
│              ▼                       ▼                          │
│       ┌─────────────┐        ┌─────────────┐                   │
│       │  Success    │        │   Error     │                   │
│       │ = true      │        │ message set │                   │
│       └─────────────┘        └─────────────┘                   │
└────────────────────────────────────────────────────────────────┘
```

---

## 4. Identified Architectural Concerns

### 4.1 Critical Issues

| Issue | Severity | Impact |
|-------|----------|--------|
| ViewModels embedded in Views | High | Testability, coupling |
| No error display to users | High | UX, data loss |
| Hardcoded API endpoints | Medium | Environment management |
| No offline queue | Medium | Data loss on network failure |
| No loading state disables form | Medium | Double submissions |

### 4.2 Concern Details

#### A. ViewModels Not Extracted

**Current (Anti-pattern):**
```swift
// QuizFlowView.swift - 300 lines
struct QuizFlowView: View {
    @StateObject private var viewModel = QuizViewModel()
    // ... view code
}

// QuizViewModel embedded at line 180
class QuizViewModel: ObservableObject {
    // ... logic
}
```

**Recommended:**
```swift
// ViewModels/QuizViewModel.swift
class QuizViewModel: ObservableObject {
    @Published var currentQuestionId: String = "main_category"
    @Published var selectedOptions: Set<String> = []
    // ... all logic
}

// Views/Quiz/QuizFlowView.swift
struct QuizFlowView: View {
    @StateObject private var viewModel = QuizViewModel()
    // ... only view code
}
```

#### B. Missing Error Handling UI

**Current:**
```swift
func submitLead() async {
    do {
        try await APIService.shared.submitLead(lead)
        submissionSuccessful = true
    } catch {
        errorMessage = error.localizedDescription  // Set but NEVER displayed
    }
}
```

**Recommended:**
```swift
@Published var showError = false
@Published var errorMessage: String?

func submitLead() async {
    do {
        try await APIService.shared.submitLead(lead)
        submissionSuccessful = true
    } catch {
        errorMessage = error.localizedDescription
        showError = true
    }
}

// In View:
.alert("Submission Failed", isPresented: $viewModel.showError) {
    Button("Retry") { Task { await viewModel.submitLead() } }
    Button("Cancel", role: .cancel) { }
} message: {
    Text(viewModel.errorMessage ?? "Please try again.")
}
```

---

## 5. Recommended Architecture (v2.0)

### 5.1 Target Directory Structure

```
KitsinianLegal/
├── App/
│   ├── KitsinianLegalApp.swift
│   ├── ContentView.swift
│   ├── AppState.swift              # EXTRACT from App
│   └── AppConfiguration.swift      # NEW: Environment config
├── Core/
│   ├── Theme/
│   │   ├── Colors.swift
│   │   ├── Typography.swift        # NEW
│   │   ├── Spacing.swift           # NEW
│   │   └── Components.swift
│   ├── Extensions/
│   │   ├── View+Extensions.swift
│   │   └── String+Extensions.swift
│   └── Protocols/
│       ├── ViewModelProtocol.swift # NEW
│       └── ServiceProtocol.swift   # NEW
├── Features/
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── Components/
│   ├── Quiz/
│   │   ├── QuizStartView.swift
│   │   ├── QuizFlowView.swift
│   │   ├── QuizResultView.swift
│   │   └── QuizViewModel.swift     # EXTRACTED
│   ├── Contact/
│   │   ├── ContactView.swift
│   │   ├── LeadFormView.swift
│   │   └── LeadFormViewModel.swift # EXTRACTED
│   ├── AccidentMode/
│   │   ├── Views/
│   │   ├── AccidentModeViewModel.swift
│   │   └── AccidentModeManager.swift
│   └── Resources/
├── Models/
│   ├── Lead.swift
│   ├── PracticeArea.swift
│   ├── Quiz.swift
│   └── Resource.swift
├── Services/
│   ├── Networking/
│   │   ├── APIService.swift
│   │   ├── NetworkMonitor.swift    # NEW
│   │   └── RequestQueue.swift      # NEW: Offline support
│   └── Storage/
│       └── LocalStorage.swift      # NEW: Caching
└── Resources/
    ├── Localizable.strings         # NEW: i18n
    └── Config.plist                # NEW: Environment vars
```

### 5.2 Component Specifications

#### AppConfiguration (NEW)

```swift
// App/AppConfiguration.swift
enum Environment {
    case development
    case staging
    case production
}

struct AppConfiguration {
    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }

    static var apiBaseURL: String {
        switch current {
        case .development:
            return "http://localhost:3000/api"
        case .staging:
            return "https://staging-api.claimit.com/api"
        case .production:
            return "https://kitsinian-legal-api.onrender.com/api"
        }
    }

    static var requestTimeout: TimeInterval = 30
}
```

#### ViewModelProtocol (NEW)

```swift
// Core/Protocols/ViewModelProtocol.swift
protocol ViewModelProtocol: ObservableObject {
    associatedtype State
    associatedtype Action

    var state: State { get }
    func send(_ action: Action)
}

// Example implementation
class QuizViewModel: ViewModelProtocol {
    enum State {
        case loading
        case question(QuizQuestion)
        case result(QuizResult)
        case error(Error)
    }

    enum Action {
        case selectOption(QuizOption)
        case goBack
        case reset
    }

    @Published var state: State = .loading

    func send(_ action: Action) {
        switch action {
        case .selectOption(let option):
            handleSelection(option)
        case .goBack:
            goBack()
        case .reset:
            reset()
        }
    }
}
```

#### Typography System (NEW)

```swift
// Core/Theme/Typography.swift
import SwiftUI

enum Typography {
    // Display
    static let display = Font.system(size: 42, weight: .black)

    // Headings
    static let h1 = Font.system(size: 34, weight: .heavy)
    static let h2 = Font.system(size: 28, weight: .bold)
    static let h3 = Font.system(size: 22, weight: .bold)
    static let h4 = Font.system(size: 18, weight: .semibold)

    // Body
    static let bodyLarge = Font.system(size: 17, weight: .regular)
    static let body = Font.system(size: 15, weight: .regular)
    static let bodySmall = Font.system(size: 13, weight: .regular)

    // Labels
    static let label = Font.system(size: 12, weight: .medium)
    static let labelSmall = Font.system(size: 10, weight: .medium)

    // Buttons
    static let button = Font.system(size: 16, weight: .semibold)
    static let buttonSmall = Font.system(size: 14, weight: .semibold)
}
```

#### Spacing System (NEW)

```swift
// Core/Theme/Spacing.swift
import SwiftUI

enum Spacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let xxxl: CGFloat = 32
    static let huge: CGFloat = 48
    static let massive: CGFloat = 64
}

enum CornerRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
    static let xxl: CGFloat = 20
    static let pill: CGFloat = 9999
}
```

#### NetworkMonitor (NEW)

```swift
// Services/Networking/NetworkMonitor.swift
import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    @Published var isConnected = true
    @Published var connectionType: NWInterface.InterfaceType?

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type
            }
        }
        monitor.start(queue: queue)
    }
}
```

#### RequestQueue (NEW - Offline Support)

```swift
// Services/Networking/RequestQueue.swift
import Foundation

actor RequestQueue {
    static let shared = RequestQueue()

    private var pendingRequests: [QueuedRequest] = []
    private let storage = UserDefaults.standard
    private let storageKey = "PendingAPIRequests"

    struct QueuedRequest: Codable {
        let id: UUID
        let endpoint: String
        let method: String
        let body: Data?
        let createdAt: Date
    }

    func enqueue(_ request: QueuedRequest) async {
        pendingRequests.append(request)
        await persistQueue()
    }

    func processQueue() async {
        guard NetworkMonitor.shared.isConnected else { return }

        for request in pendingRequests {
            do {
                try await sendRequest(request)
                await removeFromQueue(request.id)
            } catch {
                // Keep in queue for retry
            }
        }
    }

    private func persistQueue() async {
        if let data = try? JSONEncoder().encode(pendingRequests) {
            storage.set(data, forKey: storageKey)
        }
    }

    func loadQueue() async {
        if let data = storage.data(forKey: storageKey),
           let requests = try? JSONDecoder().decode([QueuedRequest].self, from: data) {
            pendingRequests = requests
        }
    }
}
```

---

## 6. Migration Plan

### Phase 1: Extract ViewModels (1-2 days)

1. Create `ViewModels/` directory
2. Move `QuizViewModel` from QuizFlowView.swift → QuizViewModel.swift
3. Move `LeadFormViewModel` from LeadFormView.swift → LeadFormViewModel.swift
4. Update imports and verify compilation

### Phase 2: Add Error Handling (1 day)

1. Add `@Published var showError: Bool` to ViewModels
2. Add `.alert()` modifiers to forms
3. Test error scenarios

### Phase 3: Environment Configuration (1 day)

1. Create `AppConfiguration.swift`
2. Move hardcoded URLs to config
3. Add Info.plist entries for environment overrides

### Phase 4: Typography & Spacing (1 day)

1. Create `Typography.swift` and `Spacing.swift`
2. Refactor views to use new constants
3. Ensure consistency across app

### Phase 5: Offline Support (2-3 days)

1. Implement `NetworkMonitor`
2. Implement `RequestQueue`
3. Integrate with `APIService`
4. Add offline indicator UI

---

## 7. Testing Strategy

### Unit Tests

```swift
// Tests/QuizViewModelTests.swift
@testable import KitsinianLegal
import XCTest

class QuizViewModelTests: XCTestCase {
    var viewModel: QuizViewModel!

    override func setUp() {
        viewModel = QuizViewModel()
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.currentQuestionId, "main_category")
        XCTAssertTrue(viewModel.selectedOptions.isEmpty)
        XCTAssertFalse(viewModel.isComplete)
    }

    func testSelectOption() {
        let option = QuizOption(id: "test", text: "Test", leadsTo: "next")
        viewModel.selectOption(option)

        XCTAssertTrue(viewModel.selectedOptions.contains("test"))
    }
}
```

### UI Tests

```swift
// UITests/QuizFlowUITests.swift
import XCTest

class QuizFlowUITests: XCTestCase {
    func testQuizCompletion() {
        let app = XCUIApplication()
        app.launch()

        // Navigate to quiz
        app.buttons["Start My Free Case Review"].tap()

        // Select options through flow
        app.buttons["Car Accident"].tap()

        // Verify progress
        XCTAssertTrue(app.staticTexts["Step 2"].exists)
    }
}
```

---

## 8. Performance Considerations

### Memory Management

- Use `@StateObject` for ViewModels (not `@ObservedObject`)
- Implement proper cleanup in `deinit`
- Use `weak self` in closures

### Network Optimization

- Implement request caching
- Use HTTP/2 for parallel requests
- Compress request/response bodies

### UI Performance

- Use `LazyVStack` for long lists
- Implement view recycling patterns
- Optimize image loading with async loading

---

## 9. Security Recommendations

### Data Protection

```swift
// Store sensitive data in Keychain, not UserDefaults
class KeychainService {
    static func store(_ value: String, forKey key: String) throws {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
}
```

### Certificate Pinning

```swift
// Add to URLSession configuration
class PinnedURLSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Implement certificate pinning
    }
}
```

---

## 10. Appendix

### A. Color System (Current)

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| claimPrimary | #0066FF | #0066FF | Primary actions |
| claimAccent | #FF6B35 | #FF6B35 | CTAs, urgency |
| claimSuccess | #00C48C | #00C48C | Confirmations |
| claimBackground | #F8FAFC | #0F172A | Page backgrounds |
| claimCardBackground | #FFFFFF | #1E293B | Card surfaces |
| claimTextPrimary | #111827 | #F8FAFC | Headings |
| claimTextSecondary | #4B5563 | #CBD5E1 | Body text |
| claimTextMuted | #9CA3AF | #94A3B8 | Captions |

### B. API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/leads | Submit new lead |
| GET | /api/health | Health check |

### C. Dependencies

- SwiftUI (iOS 17+)
- Combine
- Foundation
- No external packages

---

*Document maintained by: Development Team*
*Last updated: February 2026*
