# Project PET: Local NetBattler 📟

A MegaMan Battle Network inspired handheld experience for iOS & Android.

## Features
- **Schrittzähler** → Cyber-Meter füllt sich mit echten Schritten
- **Viren-Kämpfe** alle 2.000 Schritte (Push-Notification)
- **Battle Chips** – Ordner verwalten, Drops sammeln, tauschen
- **Slash-Geste** – Telefon stoßen um Chip einzusetzen (Beschleunigungssensor)
- **BLE Radar** – Navis in der Nähe automatisch finden
- **P2P Bluetooth** – Kämpfe und Trades ohne Internet

## Setup

### Voraussetzungen
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0
- Xcode (iOS) oder Android Studio (Android)
- Ein echtes Gerät (Sensoren + BT funktionieren nicht im Simulator)

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
