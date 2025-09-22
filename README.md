Silica
======

Silica is a window management framework for macOS. It provides many of the mechanisms that one would want when managing windows. You can access lists of windows, move and resize them, minimize and unminimize them, hide and unhide applications, and more.

Silica is very much in beta and the API is very likely to undergo breaking changes.

## Note on CGS Private APIs

This framework originally used Core Graphics Services (CGS) private APIs for advanced window management features like space switching. These APIs exist in CoreGraphics.framework but Apple doesn't provide public headers for them. The CGS functions (CGSGetSymbolicHotKeyValue, CGSSetSymbolicHotKeyEnabled, etc.) are available at runtime but require reverse-engineered headers that aren't included in this repository.

The core window management features (minimize, restore, move, resize) work without these private APIs using the Accessibility framework.

## Adding Silica to Your Swift Project

### Prerequisites

- macOS 12.0+ (or adjust based on your needs)
- Swift 5.7+
- Xcode 14+ (for Xcode integration)

### Method 1: Swift Package Manager (Git Repository)

**In your app's `Package.swift`:**
```swift
// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "YourApp",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/amoffatt/Silica-swift.git", branch: "master")
        // or use a version tag:
        // .package(url: "https://github.com/amoffatt/Silica-swift.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "YourApp",
            dependencies: ["Silica"])
    ]
)
```

### Method 2: Swift Package Manager (Local Package)

If you have a local copy of Silica:
```swift
dependencies: [
    .package(path: "/path/to/Silica")
]
```

### Method 3: Xcode GUI Integration

1. Open your project in Xcode
2. Select your project in the navigator
3. Click the project (not target) in the editor
4. Go to **Package Dependencies** tab
5. Click the **+** button
6. Enter: `https://github.com/amoffatt/Silica-swift.git`
7. Click **Add Package**
8. Select **Silica** library for your app target

## Using Silica in Your Code

### Import the module
```swift
import Foundation
import AppKit
import Silica
```

### Check accessibility permissions
```swift
guard SIUniversalAccessHelper.isAccessibilityTrusted() else {
    print("Please enable accessibility access in System Preferences")
    return
}
```

### Basic usage examples
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

## Important Notes

1. **Accessibility Access Required**: Your app MUST have accessibility permissions granted in System Preferences > Security & Privacy > Privacy > Accessibility

2. **Sandbox Restrictions**: If your app is sandboxed, it won't be able to use Silica as accessibility APIs require full system access

3. **Code Signing**: When distributing your app, ensure proper code signing and notarization

4. **App Store**: Apps using accessibility APIs typically cannot be distributed through the Mac App Store

## Example Application

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

## Troubleshooting

**Build Errors:**
- Ensure minimum macOS version matches
- Check that the Git URL or path in Package.swift is correct

**Runtime Errors:**
- Check accessibility permissions
- Ensure the app is not sandboxed
- Run with proper entitlements if needed

**Missing Methods:**
- Some CGS-dependent methods (space switching) are disabled
- Core window management (minimize, restore, move, resize) works fully