# Project PET: Local NetBattler 📟

A MegaMan Battle Network inspired handheld experience for iOS & Android.

## Features
- **Schrittzähler** → Cyber-Meter füllt sich mit echten Schritten
- **Viren-Kämpfe** alle 2.000 Schritte (Push-Notification)
- **Battle Chips** – Ordner verwalten, Drops sammeln, wegwerfen
- **Slash-Geste** – Telefon stoßen um Chip einzusetzen (Beschleunigungssensor)
- **BLE Radar** – Navis in der Nähe automatisch finden
- **P2P Bluetooth** – Kämpfe und Trades ohne Internet

## Setup

### Voraussetzungen
- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.0
- Xcode (iOS) oder Android Studio (Android)
- Ein echtes Gerät (Sensoren + BT funktionieren nicht im Simulator)

### Installation

```bash
# Abhängigkeiten installieren
flutter pub get

# App starten (Gerät anschließen)
flutter run
```

### Android Permissions
In `android/app/src/main/AndroidManifest.xml` müssen folgende Permissions vorhanden sein:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
```

### iOS Permissions
In `ios/Runner/Info.plist`:
```xml
<key>NSMotionUsageDescription</key>
<string>Wird für den Schrittzähler benötigt.</string>
<key>NSBluetoothAlwaysUsageDescription</key>
<string>Wird für Multiplayer-Kämpfe benötigt.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>Wird für Chip-Trades benötigt.</string>
```

## Projektstruktur

```
lib/
├── main.dart                         # App-Einstiegspunkt
├── core/
│   ├── app_router.dart               # Named routes
│   └── models/
│       ├── navi.dart                 # NetNavi Datenmodell (Hive)
│       └── battle_chip.dart          # BattleChip Datenmodell (Hive)
├── modules/
│   ├── singleplayer/
│   │   ├── home_screen.dart          # Haupt-PET-Anzeige
│   │   ├── chip_folder_screen.dart   # Chip-Inventar
│   │   ├── step_service.dart         # Schrittzähler + Push
│   │   └── singleplayer_provider.dart
│   ├── combat/
│   │   ├── combat_screen.dart        # Kampf-UI
│   │   └── combat_provider.dart      # Kampflogik + Slash-Geste
│   └── bluetooth/
│       ├── ble_screen.dart           # Radar-UI
│       └── ble_provider.dart         # BLE Scan + P2P
└── shared/
    └── theme/
        └── pet_theme.dart            # LCD Pixel-Art Theme
```

## Nächste Schritte (Roadmap)

- [ ] PvP-Kampf via Bluetooth (Echtzeit-Synchronisation)
- [ ] Chip-Tauschbörse via BLE
- [ ] Pixel-Art Sprites für Navis und Viren
- [ ] Sound-Effekte (8-Bit)
- [ ] Navi-Namenseingabe beim ersten Start
- [ ] Chip-Code-Kombo-System (A+A+A = Bonus)

## Lizenz
Free / Open Source – mach was draus! 🚀

## Asset Attribution
See [ASSET_ATTRIBUTION.md](ASSET_ATTRIBUTION.md) for licensing and attribution details for images sourced from Miraheze (CC BY-SA 4.0).
