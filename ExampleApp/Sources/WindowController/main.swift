//
//  main.swift
//  WindowController - Example app using Silica
//
//  Demonstrates window management capabilities
//

import Foundation
import AppKit
import Silica

class WindowController {

    static func checkAccessibility() -> Bool {
        if !SIUniversalAccessHelper.isAccessibilityTrusted() {
            print("⚠️  Accessibility access required!")
            print("Please grant access in System Preferences > Security & Privacy > Privacy > Accessibility")
            print("Add this application and restart.")
            return false
        }
        return true
    }

    static func listAllWindows() {
        print("\n📋 Listing all windows:")
        print(String(repeating: "-", count: 50))

        guard let apps = SIApplication.runningApplications() else {
            print("Failed to get applications")
            return
        }

        for app in apps {
            guard let app = app as? SIApplication else { continue }
            let appName = app.title() ?? "Unknown"
            let windows = app.windows()

            if !windows.isEmpty {
                print("\n🔸 \(appName) (\(windows.count) windows)")
                for (index, window) in windows.enumerated() {
                    let title = window.title() ?? "(no title)"
                    let isMinimized = window.isWindowMinimized()
                    print("   \(index + 1). \(title) \(isMinimized ? "[MINIMIZED]" : "")")
                }
            }
        }
    }

    static func minimizeApp(named appName: String) {
        guard let apps = SIApplication.runningApplications() else { return }

        for app in apps {
            guard let app = app as? SIApplication else { continue }
            if app.title() == appName {
                print("\n🎯 Found \(appName)")
                let windows = app.windows()
                var minimizedCount = 0

                for window in windows {
                    if !window.isWindowMinimized() {
                        window.minimize()
                        minimizedCount += 1
                    }
                }

                print("✅ Minimized \(minimizedCount) window(s)")
                return
            }
        }

        print("❌ App '\(appName)' not found")
    }

    static func restoreApp(named appName: String) {
        guard let apps = SIApplication.runningApplications() else { return }

        for app in apps {
            guard let app = app as? SIApplication else { continue }
            if app.title() == appName {
                print("\n🎯 Found \(appName)")
                let windows = app.windows()
                var restoredCount = 0

                for window in windows {
                    if window.isWindowMinimized() {
                        window.unMinimize()
                        restoredCount += 1
                    }
                }

                print("✅ Restored \(restoredCount) window(s)")
                return
            }
        }

        print("❌ App '\(appName)' not found")
    }

    static func focusedWindowInfo() {
        guard let window = SIWindow.focused() else {
            print("No focused window")
            return
        }

        print("\n🔍 Focused Window Info:")
        print("   Title: \(window.title() ?? "(no title)")")
        print("   App: \(window.app()?.title() ?? "Unknown")")
        print("   Frame: \(window.frame())")
        print("   Minimized: \(window.isWindowMinimized())")
        print("   Movable: \(window.isMovable())")
        print("   Resizable: \(window.isResizable())")
    }
}

// MARK: - Main Program

print("🚀 Window Controller - Silica Example")
print("=====================================\n")

guard WindowController.checkAccessibility() else {
    exit(1)
}

print("✅ Accessibility access granted\n")
print("Available commands:")
print("  1. List all windows")
print("  2. Minimize Safari")
print("  3. Restore Safari")
print("  4. Get focused window info")
print("  5. Minimize all windows")
print("  q. Quit\n")

while true {
    print("Enter command: ", terminator: "")
    guard let input = readLine() else { break }

    switch input.lowercased() {
    case "1":
        WindowController.listAllWindows()
    case "2":
        WindowController.minimizeApp(named: "Safari")
    case "3":
        WindowController.restoreApp(named: "Safari")
    case "4":
        WindowController.focusedWindowInfo()
    case "5":
        print("\n🌀 Minimizing all windows...")
        guard let windows = SIWindow.visibleWindows() else {
            print("Failed to get windows")
            continue
        }
        for window in windows {
            window.minimize()
        }
        print("✅ Done")
    case "q":
        print("👋 Goodbye!")
        exit(0)
    default:
        print("Invalid command")
    }

    print()
}