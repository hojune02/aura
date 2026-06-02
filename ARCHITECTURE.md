# Architecture

aura is a native SwiftUI app with a small local architecture:

- `Models/` contains breathing patterns, phases, session records, themes, and premium feature definitions.
- `Stores/` contains ObservableObject stores for app settings, local session stats, and StoreKit 2 purchases.
- `Services/` contains the breathing session engine and haptic feedback wrapper.
- `Views/` contains the main SwiftUI screens.
- `Components/` contains reusable visual pieces such as the breathing orb, progress ring, primary button, stat card, and theme background.

State is intentionally local:

- `AppSettingsStore` persists haptics, sound, selected theme, and a custom pattern to UserDefaults.
- `SessionStatsStore` persists completed sessions to UserDefaults and computes streaks from local records.
- `PurchaseStore` loads `com.aura.premium` with StoreKit 2 and listens for transaction updates.

The breathing timer is owned by `BreathingSessionEngine`. The view observes phase and completion changes, then triggers haptics and records a completed session exactly once.

No backend, login, analytics, tracking SDKs, or third-party dependencies are used.
