# App Review Compliance

aura is an original SwiftUI app for guided breathing resets.

- It does not copy another app's branding, assets, name, UI, code, screenshots, or metadata.
- It provides meaningful native functionality beyond a webview or empty shell.
- It includes guided breathing sessions, animated visual pacing, local stats, settings, themes, haptics, generated sound cues, and StoreKit 2 premium unlocks.
- It avoids medical claims and does not claim to treat anxiety, depression, insomnia, panic disorder, ADHD, or any medical condition.
- It uses language such as "may help you feel calmer" and "designed for focus and relaxation."
- It does not collect personal data.
- It does not include analytics or tracking SDKs.
- It uses local-only storage through UserDefaults.
- It is an English-only app.
- Sound cues are generated locally in-app; no copyrighted sounds are included.

## Guideline 2.1(b) Resubmission Checklist

Apple rejected version 1.0 build 2 on June 4, 2026 because the non-consumable In-App Purchase was not submitted for review.

Before resubmitting:

- In App Store Connect, confirm the In-App Purchase product ID is exactly `com.aura.premium`.
- Type: Non-Consumable.
- Reference Name: `aura Premium`.
- Display Name: `aura Premium`.
- Description: `Unlock premium breathing resets, custom sessions, extra themes, and detailed local stats.`
- Add pricing and country/region availability.
- Upload the App Review screenshot: `aura/AppStore/iap_review_screenshot.png`.
- Confirm the IAP status is `Ready to Submit`.
- On the app version page, attach/select `com.aura.premium` in the In-App Purchases and Subscriptions section.
- Upload and select a new binary. The next binary is version `1.0`, build `3`.
- Submit the app version and the IAP together.

Suggested reply to App Review:

> Thank you. We have configured and submitted the non-consumable In-App Purchase `com.aura.premium` with the new app binary. The product includes required metadata, pricing, availability, and an App Review screenshot. Please continue review with version 1.0 build 3.
