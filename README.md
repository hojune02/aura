# aura

aura is a SwiftUI iOS app for 60-second breathing resets for focus, study, coding stress, interviews, exams, and sleep routines.

The app is English-only, local-only, and designed to run without a backend, login, analytics, or third-party dependencies.

## Requirements

- iOS 17+
- Xcode 26 or newer recommended
- Swift 5.9+
- XcodeGen to generate the project from `project.yml`

## Generate The Xcode Project

`xcodegen` is not installed in the current environment. Install it, then generate the project:

```sh
brew install xcodegen
xcodegen generate
open aura.xcodeproj
```

Run the `aura` scheme on an iPhone simulator or device.

## StoreKit 2

The premium unlock uses a one-time non-consumable product:

```text
com.aura.premium
```

The app includes `aura.storekit` for local StoreKit testing. In App Store Connect, create the same non-consumable product ID, add localized display text and pricing, then attach the StoreKit configuration to the Xcode scheme if it is not already selected after generation.

The app remains usable if StoreKit products are not configured. Free features are always available.

## Free Features

- 60s Focus Reset
- Box Breathing
- Basic stats
- Haptics

## Premium Features

- Sleep 4-7-8
- Interview Calm
- Exam Stress Reset
- Custom session duration and pattern
- Sunset and Forest themes
- Detailed stats

## WidgetKit

WidgetKit is intentionally left as a follow-up because this scaffold uses a single XcodeGen app target. Add a widget extension target once the app target is generated, then share today's session count through an app group and deep-link to `aura://start`.
