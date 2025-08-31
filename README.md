# SpaceX iOS App

A SwiftUI-based iOS application that displays SpaceX company information and launch history using the official SpaceX API.

## Features

### ✅ Must Have Features

- **UI**: SwiftUI with one non-trivial UIKit view (LaunchDetailViewController)
- **Memory Efficient**: Uses lazy loading and proper memory management
- **Filters**: Filter launches by year, success status, and sort order
- **Launch Details**: Tap on any launch to view detailed information
- **Network Layer**: Implements SpaceX API integration
- **Parsing**: Complete API response parsing for Company and Launch data
- **Unit Tests**: Comprehensive test coverage for ViewModel
- **Version Control**: Git repository ready

### 🚀 Nice to Have Features

- **Caching**: Built-in caching using URLSession cache policies
- **Offline Mode**: Graceful handling of network failures
- **Modern iOS Features**: Uses @Observable macro and latest SwiftUI patterns

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern with a **feature-based** organization structure:

### Components (General Components for Whole App)

- `AsyncImageView.swift` - Reusable image loader component

### Screens

#### SpaceXHomeScreen

- **Models**
  - `Company.swift` - SpaceX company information
  - `Launch.swift` - Individual launch data with computed properties
- **ViewModels**
  - `SpaceXViewModel.swift` - Main view model using @Observable macro
- **Views**
  - `SpaceXHomeScreen.swift` - Main screen view
  - `CompanyInfoView.swift` - Company information component
  - `LaunchItemView.swift` - Individual launch item component
  - `FilterView.swift` - Filter interface
  - **UIKitView**
    - `LaunchDetailViewController.swift` - UIKit detail view (required)

### Services & Network

- `SpaceXService.swift` - API service layer
- `NetworkManager.swift` - Enhanced networking with caching
- `DomainsConstants.swift` - API endpoints

## API Integration

The app integrates with the official SpaceX API:

- **Company Info**: `https://api.spacexdata.com/v4/company`
- **All Launches**: `https://api.spacexdata.com/v5/launches`

## UI Design

The app follows the provided wireframe design:

- Header with "SpaceX" title and filter icon
- Company information section at the top
- Launches list with mission patches, details, and success indicators
- Filter modal for year, success status, and sort order
- Launch detail view with full information and external links

## Key Features

### Filtering System

- Filter by launch year
- Show only successful launches
- Sort by date (ascending/descending)
- Clear all filters option

### Launch Details

- Mission patch images
- Launch date and time
- Rocket information
- Days since/until launch
- Success/failure indicators
- External links (Article, Wikipedia, Webcast)

### Memory Management

- Lazy loading of images
- Proper cancellation of network requests
- Efficient list rendering with LazyVStack

### Error Handling

- Network error display
- Retry functionality
- Graceful fallbacks for missing data

## Testing

The app includes comprehensive unit tests:

- ViewModel data loading tests
- Filter functionality tests
- Error handling tests
- Mock service for testing

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository
2. Open `Devskiller.xcodeproj` in Xcode
3. Build and run the project

## Project Structure

```
Devskiller/
├── Components/
│   └── AsyncImageView.swift
├── Screens/
│   └── SpaceXHomeScreen/
│       ├── Models/
│       │   ├── Company.swift
│       │   └── Launch.swift
│       ├── ViewModels/
│       │   └── SpaceXViewModel.swift
│       └── Views/
│           ├── SpaceXHomeScreen.swift
│           ├── CompanyInfoView.swift
│           ├── LaunchItemView.swift
│           ├── FilterView.swift
│           └── UIKitView/
│               └── LaunchDetailViewController.swift
├── Services/
│   └── SpaceXService.swift
├── Network/
│   ├── NetworkManager.swift
│   └── DomainsConstants.swift
└── ContentView.swift
```

## Technical Highlights

- **@Observable Macro**: Modern SwiftUI state management
- **Combine Framework**: Reactive programming for data flow
- **Protocol-Oriented Design**: Testable and maintainable code
- **Memory Efficient**: Proper resource management
- **Caching Strategy**: URLSession cache policies for offline support
- **UIKit Integration**: Required non-trivial UIKit view
- **Error Handling**: Comprehensive error management
- **Unit Testing**: Mock services and testable architecture
- **Feature-Based Architecture**: Organized by features for better maintainability

## Future Enhancements

- Infinite scrolling for large launch lists
- Certificate pinning for enhanced security
- Dark/light mode support
- Push notifications for upcoming launches
- Offline data persistence with Core Data
