# Shadow Shepherds iOS

This is a native iOS wrapper for the bundled Shadow Shepherds HTML5 canvas game. The app runs the game locally inside `WKWebView`; it does not load remote code or require a server.

## Project contents

- `ShadowShepherds.xcodeproj` — Xcode project.
- `ShadowShepherds/AppDelegate.swift` and `SceneDelegate.swift` — app lifecycle.
- `ShadowShepherds/GameViewController.swift` — locked-down `WKWebView` game host.
- `ShadowShepherds/Web/` — bundled game files.
- `ShadowShepherds/Assets.xcassets/AppIcon.appiconset` — generated iOS app icons.
- `ShadowShepherds/PrivacyInfo.xcprivacy` — declares no tracking and no collected data.
- `ExportOptions-AppStore.plist` — starter export options for App Store Connect upload.

## Required before deploying

Apple signing cannot be completed without your Apple Developer account.

In Xcode:

1. Open `ShadowShepherds.xcodeproj`.
2. Select the `ShadowShepherds` target.
3. Set `Signing & Capabilities` → `Team` to your Apple Developer Team.
4. Change `Bundle Identifier` from `com.yourcompany.shadowshepherds` to your real unique app ID.
5. Run on a physical iPhone/iPad in landscape.
6. Archive with `Product → Archive`, then distribute to TestFlight/App Store Connect.

## CLI archive example

Replace the team and bundle identifier in Xcode first, then:

```bash
xcodebuild \
  -project ShadowShepherds.xcodeproj \
  -scheme ShadowShepherds \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  archive \
  -archivePath build/ShadowShepherds.xcarchive
```

Then export:

```bash
xcodebuild \
  -exportArchive \
  -archivePath build/ShadowShepherds.xcarchive \
  -exportOptionsPlist ExportOptions-AppStore.plist \
  -exportPath build/AppStore
```

## Notes

- The app is landscape-only.
- The original service worker remains bundled for web/PWA use, but it is intentionally a no-op inside the iOS file-based app runtime.
- External navigation is blocked by the native wrapper, keeping the app self-contained.
- `localStorage` is used by the game and should persist inside the app's WebKit data store.
