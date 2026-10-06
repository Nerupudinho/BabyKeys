# BabyKeys

**A free macOS toy for babies and toddlers.** Open it, hand over the laptop, and every key or click becomes a colorful shape on a dimmed fullscreen overlay — circles, squares, stars — instead of Mail, Safari, or a half-deleted file.

Built for my toddler, so a baby can mash a MacBook and the grown-up still has a computer afterwards.

[Install](#install) · Free and open source

---

## What you see

A true fullscreen overlay: dock, menu bar, and window chrome gone. Your desktop stays faintly visible behind a dim veil. Each keypress or mouse click springs in a soft-edged shape — circles, squares, stars in bright colors — that fades after a moment. Up to 50 shapes at once. That is the whole product.

## Features

- **Every key or click is a shape** — circles, squares, stars; random vibrant colors; spring in, fade out (~1.5s)
- **True fullscreen** — hides the Dock, menu bar, and system chrome
- **Harder to wander off** — blocks accidental app switching and scroll / swipe / pinch gestures so a mash session stays in BabyKeys
- **Parent exit** — hold **Esc + Space** together for **2 seconds** to quit (long enough that a baby almost never holds both)
- **Adult shortcut** — **⌘Q** quits immediately
- **No account, no network, no ads** — local SwiftUI app; optional diagnostic log at `~/Library/Logs/BabyKeys/babykeys.log`
- **Will not relaunch itself at login** — so a session that was open at shutdown does not lock the Mac on the next boot

BabyKeys is a toy, not a lesson plan. It does not speak letters, play songs, or teach colors.

## Install

**From source**

```bash
git clone https://github.com/Nerupudinho/BabyKeys.git
cd BabyKeys
swift build -c release
open .build/release/BabyKeys
```

There is no signed or notarized download yet. You need a Mac you are allowed to run unsigned local builds on. If Gatekeeper complains, open System Settings → Privacy & Security and allow the app you just built.

## How to exit

A baby should not be able to quit by mashing. A parent should never be trapped.

| Who | What |
|---|---|
| Parent | Hold **Esc + Space** together for **2 seconds** |
| Parent | **⌘Q** quits immediately |
| Last resort | **⌘⌥Esc** (Force Quit) works — the app does not disable it |

If Esc + Space does nothing, you are not holding both keys for the full count. Release and try again.

## Requirements

- macOS 14 Sonoma or later
- Apple Silicon or Intel
- Bundle ID `com.ganesh.BabyKeys` · version 1.0

## Stack

Swift 5.9 · SwiftUI · macOS 14+

## Free and open

BabyKeys is free. There is no paid tier and no advertising. Source: [github.com/Nerupudinho/BabyKeys](https://github.com/Nerupudinho/BabyKeys).

If you want the same thing for your kid, clone it, build it, change the colors. Issues and PRs welcome if something actually breaks a mash session.

## Not those other BabyKeys

The name is already used by an old Windows toy and by unrelated Mac keyboard-lock utilities. This repo is the free SwiftUI fullscreen shape toy (`com.ganesh.BabyKeys`). It is not a locker that hides input while you keep working in other apps.

---

Use it if it helps your baby too.
