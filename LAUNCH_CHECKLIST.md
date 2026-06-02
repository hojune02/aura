# Launch Checklist

- Generate `aura.xcodeproj` with XcodeGen.
- Set the Apple Developer Team in Xcode.
- Confirm bundle ID: `com.hojunekim.aura`.
- Create the non-consumable product in App Store Connect: `com.aura.premium`.
- Attach `aura.storekit` to the debug scheme for local purchase testing.
- Test free sessions on iPhone SE, standard iPhone, and large iPhone simulators.
- Test premium purchase, restore, locked presets, custom pattern saving, and premium themes.
- Verify haptics on a physical device.
- Verify the generated local sound cue on a physical device.
- Confirm the App Icon and launch assets in the final archive.
- Capture screenshots using the plan in `aura/AppStore/screenshot_plan.md`.
- Review all App Store metadata for medical-claim wording.
- Deploy the static privacy/support site from `docs/`.
- Add WidgetKit extension if desired: share today's count through an app group and deep-link to `aura://start`.
