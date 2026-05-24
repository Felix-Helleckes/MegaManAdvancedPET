How to test PvP locally

1) Start an Android emulator or use two physical Android devices on the same Wi‑Fi/Bluetooth range.

2) Ensure Bluetooth is enabled on both devices and the app is allowed to access location/BLE.

3) On device A: Open the app, go to the Bluetooth screen and press "Advertise" (or start advertising implemented in `BleProvider`).

4) On device B: Open the Bluetooth screen and press "Scan". The other device should appear as a discovered Navi.

5) Tap the discovered device to connect, then open the battle UI and select PvP — the app will exchange messages via BLE (messages handled in `BleProvider.messageStream`).

Notes & troubleshooting
- If the Android emulator is not detected by `flutter devices`, open Android Studio → AVD Manager and start a virtual device manually.
- If `emulator-5554` appears as `offline`, try restarting ADB:

```powershell
adb kill-server
adb start-server
adb devices -l
```

- If the emulator still shows `offline`, close and relaunch the AVD from Android Studio.
- On Windows, ensure Android SDK tools/emulator are installed and added to PATH, or start the emulator from Android Studio.

If you want, I can try to create a new AVD via the CLI (`avdmanager`) and start it, but that requires Android SDK command-line tools to be installed and on PATH. I can guide you through that interactively.
