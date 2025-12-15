# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TMDb iOS app using **SwiftUI** with **Event-Driven Coordinator Pattern**. Three tabs: Movies, TV Shows, People.

## Build & Run

```bash
# Open in Xcode
open CoordinatorDeneme.xcodeproj

# Build & Run
Cmd + R

# Clean build
Cmd + Shift + K
```

**API Configuration:** Update `Core/Configuration/AppConfiguration.swift` with TMDb API key from https://www.themoviedb.org/settings/api

## Architecture: Event-Driven Coordinator Pattern

### Core Principle
**Strict separation of concerns:** View → ViewModel → Coordinator

- **View**: UI only, zero navigation logic
- **ViewModel**: Business logic + event emission, zero direct navigation
- **Coordinator**: Navigation logic only, handles all UI state (sheets, alerts, toasts, navigation)

### Navigation Flow

```
View (user action)
  ↓
ViewModel (emit event via coordinator?.handle())
  ↓
Coordinator (execute navigation logic)
  ↓
@Published properties update
  ↓
View re-renders
```

### Coordinator Hierarchy

```
MainTabCoordinator (owns tab selection)
  ├── MoviesCoordinator (weak parent reference)
  ├── TVShowsCoordinator (weak parent reference)
  └── PeopleCoordinator (weak parent reference)
```

Each feature coordinator has `weak var parent: MainTabCoordinator?` for cross-tab navigation.

### Coordinator Event Types

Every coordinator handles these event categories via `func handle(_ event: Event)`:

1. **Sheet Presentations** (`.sheet(item:)`)
   - Example: `.showMovieDetail(Int)`, `.showFilterSheet`

2. **Alerts** (`.alert(item:)`)
   - `.showError(String)` - simple error alert
   - `.showAlert(.confirmation(...))` - two-button confirmation

3. **Toast Messages** (overlay, auto-dismiss after 3s)
   - `.showToast(String, .success/.error/.info)`

4. **Push Navigation** (NavigationStack path)
   - `.push(Destination)` - add to path
   - `.pop` - remove last
   - `.popToRoot` - clear entire path

5. **Tab Switching**
   - Via parent coordinator: `parent?.select(.movies)`

6. **External Navigation**
   - `.openURL(URL)` - opens in Safari

### Coordinator State Properties

```swift
@Published var path = NavigationPath()           // Push navigation
@Published var sheet: Sheet?                     // Modal sheets
@Published var alert: AlertType?                 // Alerts
@Published var toast: ToastMessage?              // Toast notifications
```

## Adding New Features

### 1. Create Feature Structure
```
Features/NewFeature/
├── Coordinator/NewFeatureCoordinator.swift
├── ViewModel/NewFeatureViewModel.swift
├── View/NewFeatureView.swift
└── Navigation/NewFeatureNavigation.swift
```

### 2. Coordinator Template
```swift
@MainActor
final class NewFeatureCoordinator: ObservableObject {
    weak var parent: MainTabCoordinator?
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var alert: AlertType?
    @Published var toast: ToastMessage?

    enum Sheet: Identifiable {
        case detail(Int)
        var id: String { /* unique id */ }
    }

    enum Event {
        case showDetail(Int)
        case dismissSheet
    }

    func handle(_ event: Event) {
        switch event {
        case .showDetail(let id):
            sheet = .detail(id)
        case .dismissSheet:
            sheet = nil
        }
    }
}
```

### 3. ViewModel Pattern
```swift
@MainActor
final class NewFeatureViewModel: ObservableObject {
    @Published var items: [Item] = []
    weak var coordinator: NewFeatureCoordinator?
    private let networkService: NetworkServiceProtocol

    func itemTapped(_ id: Int) {
        coordinator?.handle(.showDetail(id))  // Event emission
    }
}
```

### 4. Navigation Wrapper
```swift
struct NewFeatureNavigation: View {
    @ObservedObject var coordinator: NewFeatureCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            NewFeatureView(viewModel: createViewModel())
                .navigationDestination(for: Destination.self) { /* ... */ }
        }
        .sheet(item: $coordinator.sheet) { /* ... */ }
        .alert(item: $coordinator.alert) { /* ... */ }
        .overlay { /* Toast overlay */ }
    }

    private func createViewModel() -> NewFeatureViewModel {
        let vm = NewFeatureViewModel()
        vm.coordinator = coordinator
        return vm
    }
}
```

### 5. Wire to MainTabCoordinator
Add new tab case, create coordinator instance, set parent reference.

## Network Layer

**Protocol-based with dependency injection:**

- `NetworkServiceProtocol` - generic `async throws` request method
- `Endpoint` protocol - defines baseURL, path, method, queryItems
- `TMDbEndpoint` enum - implements Endpoint for TMDb API
- JSON decoding uses `.convertFromSnakeCase` strategy

**Adding new endpoint:**
```swift
// In TMDbEndpoint enum
case newEndpoint(param: Type)

var path: String {
    case .newEndpoint(let param):
        return "/path/\(param)"
}
```

## Key Architectural Rules

1. **ViewModels NEVER navigate directly** - Always emit events to coordinator
2. **Coordinators NEVER contain business logic** - Only navigation/UI state
3. **Views are dumb** - Only render UI and call ViewModel methods
4. **Use weak references** - ViewModel → Coordinator (weak), Child Coordinator → Parent (weak)
5. **@MainActor everywhere** - All UI-related classes marked @MainActor
6. **Sheet vs Push:**
   - Sheet: Independent contexts, detail views, forms
   - Push: Hierarchical navigation, master-detail patterns

## Modal vs Push Navigation

**When to use `.sheet()`:**
- Detail views that need toolbar/navigation bar
- Self-contained flows
- Forms and filters

**When to use `.push()`:**
- Hierarchical drill-down
- Breadcrumb-style navigation

**Both can be used in same coordinator** - NavigationStack handles push, sheet modifier handles modals.

## Testing ViewModels

Mock the coordinator to test event emission:
```swift
final class MockCoordinator: MoviesCoordinator {
    var receivedEvents: [Event] = []
    override func handle(_ event: Event) {
        receivedEvents.append(event)
    }
}
```

## Common Patterns

**Cross-tab navigation:**
```swift
coordinator?.handle(.switchToTVShows)
// Internally calls: parent?.select(.tvShows)
```

**Confirmation dialogs:**
```swift
coordinator?.handle(.showAlert(.confirmation(
    title: "Delete",
    message: "Are you sure?",
    action: { self.performDelete() }
)))
```

**Success feedback:**
```swift
coordinator?.handle(.showToast("Saved!", .success))
```
