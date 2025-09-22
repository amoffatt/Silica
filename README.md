Silica
======

Silica is a window management framework for OS X. It provides many of the mechanisms that one would want when managing windows. You can access lists of windows, move and resize them, minimize and unminimize them, hide and unhide applications, and more.

Silica is very much in beta and the API is very likely to undergo breaking changes.

## Note on CGS Private APIs

This framework originally used Core Graphics Services (CGS) private APIs for advanced window management features like space switching. These APIs exist in CoreGraphics.framework but Apple doesn't provide public headers for them. The CGS functions (CGSGetSymbolicHotKeyValue, CGSSetSymbolicHotKeyEnabled, etc.) are available at runtime but require reverse-engineered headers that aren't included in this repository.

The core window management features (minimize, restore, move, resize) work without these private APIs using the Accessibility framework.
