# TMDb Coordinator Pattern Demo

SwiftUI iOS app demonstrating the **Event-Driven Coordinator Pattern** with TMDb API integration.

## Features

- 🎬 Browse popular movies
- 📺 Browse popular TV shows
- 👥 Browse popular people
- 🧭 Clean navigation architecture using Coordinator pattern
- 📱 Modern SwiftUI with NavigationStack
- 🎯 Event-driven communication between layers

## Architecture

**Event-Driven Coordinator Pattern:**

```
View → ViewModel → Coordinator → UI State Update
```

- **View**: Pure UI, no navigation logic
- **ViewModel**: Business logic, emits navigation events
- **Coordinator**: Handles all navigation (sheets, alerts, push, tabs)

## Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd CoordinatorDeneme
```

### 2. Configure API Key

```bash
# Copy the example config file
cp CoordinatorDeneme/Core/Configuration/AppConfiguration.swift.example \
   CoordinatorDeneme/Core/Configuration/AppConfiguration.swift
```

Get your API key from [TMDb](https://www.themoviedb.org/settings/api) and update `AppConfiguration.swift`:

```swift
static let tmdbAPIKey = "your_api_key_here"
```

### 3. Open in Xcode

```bash
open CoordinatorDeneme.xcodeproj
```

### 4. Build and Run

Press `Cmd + R` or click the Run button in Xcode.

## Project Structure

```
CoordinatorDeneme/
├── Core/
│   ├── Network/           # Generic network layer
│   ├── Models/            # Data models (Movie, TVShow, Person)
│   ├── Navigation/        # MainTabCoordinator
│   └── Configuration/     # App configuration (API keys)
├── Features/
│   ├── Movies/
│   │   ├── Coordinator/   # Navigation logic
│   │   ├── ViewModel/     # Business logic
│   │   ├── View/          # UI components
│   │   └── Navigation/    # NavigationStack wrapper
│   ├── TVShows/
│   └── People/
└── App/
    └── RootView.swift     # Tab-based root view
```

## Coordinator Pattern

Each feature has its own coordinator that handles:

- **Sheet presentations** - Modal views
- **Alerts** - Error messages, confirmations
- **Toast notifications** - Auto-dismissing feedback
- **Push navigation** - Hierarchical navigation
- **Tab switching** - Cross-feature navigation
- **External URLs** - Opening Safari

### Example Usage

```swift
// In ViewModel
func movieTapped(_ id: Int) {
    coordinator?.handle(.showMovieDetail(id))
}

func showError(_ message: String) {
    coordinator?.handle(.showError(message))
}

func showSuccess() {
    coordinator?.handle(.showToast("Success!", .success))
}
```

## Key Technologies

- SwiftUI
- NavigationStack (iOS 16+)
- Async/Await
- Combine
- Protocol-oriented networking
- MVVM + Coordinator

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- TMDb API Key

## Contributing

Feel free to open issues or submit pull requests.

## License

MIT License - feel free to use this project for learning purposes.

## Resources

- [TMDb API Documentation](https://developers.themoviedb.org/3)
- [SwiftUI Navigation](https://developer.apple.com/documentation/swiftui/navigation)
- [Coordinator Pattern](https://www.hackingwithswift.com/articles/175/advanced-coordinator-pattern-tutorial-ios)
