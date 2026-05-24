# Project PET: Local NetBattler 📟

An open-source, MegaMan Battle Network–inspired handheld experience for iOS & Android. This project recreates the feel of the Advanced PET: step-driven encounters, collectible Battle Chips, and local-only multiplayer via Bluetooth.

## Current status (short)
- Assets: many BattleChip images have been downloaded and are stored under `assets/images/chips/` (deduplicated).
- `BattleChip.fullCatalog`: generated placeholder entries for `chip_001`..`chip_320` so every numeric asset can be represented in-app.
- Verification tool: `tools/check_chip_assets.py` produces `reports/missing_chip_images.txt` and `reports/unreferenced_chip_images.txt` to help ensure completeness.
- UI: chip detail shows TYPE / CLASS / ELEM / AT in English and prefers local assets when available.
- Combat logic: basic resolver implemented; support/defense/heal behaviors exist but need further tuning to match wiki semantics.

## Quick start

### Requirements
- Flutter SDK ≥ 3.0
- Xcode (macOS / iOS) or Android Studio (Android)
- A physical device for testing sensors and Bluetooth (emulators do not fully support these features)

### Install & run

```bash
# install deps
flutter pub get

# run on connected device
flutter run
```

### Developer utilities
- Asset checker: run the asset verification script to generate reports:

```bash
python tools/check_chip_assets.py
```

Reports are written to `reports/missing_chip_images.txt` and `reports/unreferenced_chip_images.txt`.

## Important permissions

Android (`android/app/src/main/AndroidManifest.xml`): include Bluetooth and motion/location permissions as needed for your target SDK.

iOS (`ios/Runner/Info.plist`): add `NSMotionUsageDescription`, `NSBluetoothAlwaysUsageDescription`, and related keys with appropriate user-facing strings.

## Project layout (high level)

```
lib/
├─ main.dart
├─ core/
│  ├─ models/
│  │  ├─ battle_chip.dart   # Hive model; contains generated `fullCatalog`
│  │  └─ navi.dart
├─ modules/
│  ├─ singleplayer/         # home, folder, step service, provider
│  ├─ combat/               # combat UI + resolver
│  └─ bluetooth/            # BLE scan + P2P
tools/
├─ check_chip_assets.py     # asset verification script
assets/
└─ images/chips/            # downloaded BattleChip images
```

## Roadmap / next work
- Finalize and tune combat rules to match wiki semantics (attack/support/defense/heal).
- Enrich `fullCatalog` with real metadata (names, damage, category) parsed from the wiki.
- Add unit tests for combat resolver and asset-checking automation.
- Implement robust BLE PvP sync and trade flows.

## License
Free / Open Source — feel free to fork and improve.

## Asset attribution
See [ASSET_ATTRIBUTION.md](ASSET_ATTRIBUTION.md) for licensing and attribution details for images sourced from Miraheze (CC BY-SA 4.0).
