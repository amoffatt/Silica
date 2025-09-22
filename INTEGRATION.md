# Silica Integration Guide

## Including Silica in Your Swift App

### Prerequisites

- macOS 12.0+ (or adjust based on your needs)
- Swift 5.7+
- Xcode 14+ (for Xcode integration)

### Method 1: Swift Package Manager (Local Package)

1. **In your app's `Package.swift`:**

```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(path: "/path/to/Silica")
    ],
    targets: [
        .executableTarget(
            name: "YourApp",
            dependencies: ["Silica"])
    ]
)
```

2. **Build your app:**
```bash
swift build
```

### Method 2: Swift Package Manager (Git Repository)

1. **First, push Silica to a Git repository:**
```bash
cd /path/to/Silica
git remote add origin https://github.com/yourusername/Silica.git
git push -u origin master
```

2. **In your app's `Package.swift`:**
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/Silica.git", branch: "master")
    // or use a version tag:
    // .package(url: "https://github.com/yourusername/Silica.git", from: "1.0.0")
]
```

### Method 3: Xcode GUI Integration

1. Open your project in Xcode
2. Select your project in the navigator
3. Click the project (not target) in the editor
4. Go to **Package Dependencies** tab
5. Click the **+** button
6. Either:
   - Enter the Git URL for remote package
   - Click **Add Local...** for local package
7. Click **Add Package**
8. Select **Silica** library for your app target

### Using Silica in Your Code

1. **Import the module:**
```swift
import Foundation
import AppKit
import Silica
```

2. **Check accessibility permissions:**
```swift
guard SIUniversalAccessHelper.isAccessibilityTrusted() else {
    print("Please enable accessibility access in System Preferences")
    return
}
```

3. **Basic usage examples:**
```swift
// Get all applications
let apps = SIApplication.runningApplications()

// Find a specific app
for app in apps ?? [] {
    guard let app = app as? SIApplication else { continue }
    if app.title() == "Safari" {
        // Work with Safari
        let windows = app.windows()
        for window in windows {
            // Minimize window
            window.minimize()

            // Check if minimized
            if window.isWindowMinimized() {
                // Restore window
                window.unMinimize()
            }
        }
    }
}

// Get focused window
if let focusedWindow = SIWindow.focused() {
    print("Focused: \(focusedWindow.title() ?? "Unknown")")
}

// Get all visible windows
if let visibleWindows = SIWindow.visibleWindows() {
    for window in visibleWindows {
        // Process each visible window
    }
}
```

### Important Notes

1. **Accessibility Access Required**: Your app MUST have accessibility permissions granted in System Preferences > Security & Privacy > Privacy > Accessibility

2. **Sandbox Restrictions**: If your app is sandboxed, it won't be able to use Silica as accessibility APIs require full system access

3. **Code Signing**: When distributing your app, ensure proper code signing and notarization

4. **App Store**: Apps using accessibility APIs typically cannot be distributed through the Mac App Store

### Example Project Structure

```
YourApp/
├── Package.swift
└── Sources/
    └── YourApp/
        └── main.swift
```

### Troubleshooting

**Build Errors:**
- Ensure Silica is built first: `cd /path/to/Silica && swift build`
- Check that the path in Package.swift is correct
- Verify minimum macOS version matches

**Runtime Errors:**
- Check accessibility permissions
- Ensure the app is not sandboxed
- Run with proper entitlements if needed

**Missing Methods:**
- Some CGS-dependent methods (space switching) are disabled
- Core window management (minimize, restore, move, resize) works fully

### Complete Example App

See `/ExampleApp/Sources/WindowController/main.swift` for a complete working example that demonstrates:
- Listing all windows
- Minimizing/restoring specific apps
- Getting focused window information
- Interactive command-line interface

To run the example:
```bash
cd ExampleApp
swift run WindowController
```