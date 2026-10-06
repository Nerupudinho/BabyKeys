# BabyKeys

A macOS toy app for babies and toddlers. Every keypress or mouse click spawns a colorful animated shape on screen — circles, squares, and stars in random vibrant colors. Safe, fullscreen, and impossible to accidentally exit.

## What it does

- Runs in true fullscreen — hides dock, menu bar, and system UI
- Every key or mouse click creates an animated shape at the cursor position
- Shapes spring in, then fade out after 1.5 seconds
- Up to 50 shapes on screen at once
- Blocks accidental system navigation (no app switching, no force quit, no scroll gestures)

## Requirements

- macOS 14 (Sonoma) or later
- Apple Silicon or Intel Mac

## Build & Run

```bash
swift build -c release
open .build/release/BabyKeys
```

Or open the pre-built `BabyKeys.app` bundle directly.

## How to exit

Hold **ESC + SPACE** together for 3 seconds to gracefully quit. The longer hold prevents a baby from exiting by mashing keys.

## Stack

Swift 5.9 · SwiftUI · macOS 14+

## Free and open

License: MIT, see LICENSE
