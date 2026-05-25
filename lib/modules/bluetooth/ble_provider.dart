// ignore_for_file: unused_field
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

/// Service UUIDs – both devices need to share these to find each other.
class PetBle {
  static const String serviceUuid  = '12345678-1234-1234-1234-1234567890ab';
  static const String txCharUuid   = '12345678-1234-1234-1234-1234567890ac'; // notify
  static const String rxCharUuid   = '12345678-1234-1234-1234-1234567890ad'; // write
}

enum BleState { idle, scanning, advertising, connected, battling }

class DiscoveredPet {
  final BluetoothDevice device;
  final String naviName;
  final int naviLevel;
  final int rssi;

  DiscoveredPet({
    required this.device,
    required this.naviName,
    required this.naviLevel,
    required this.rssi,
  });
}

class BleProvider extends ChangeNotifier {
  BleState _state = BleState.idle;
  final List<DiscoveredPet> _nearbyPets = [];
  BluetoothDevice? _connectedDevice;
  String _statusMessage = 'Not connected';
  String _deviceId = '';

  // Incoming message stream for the combat module
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  BleState get state => _state;
  List<DiscoveredPet> get nearbyPets => List.unmodifiable(_nearbyPets);
  BluetoothDevice? get connectedDevice => _connectedDevice;
  String get statusMessage => _statusMessage;

  StreamSubscription? _scanSub;
  BluetoothCharacteristic? _txChar;
  BluetoothCharacteristic? _rxChar;

  BleProvider() {
    _initDeviceId();
  }

  Future<void> _initDeviceId() async {
    final box = Hive.box('settings');
    String? id = box.get('deviceId') as String?;
    if (id == null) {
      id = const Uuid().v4().substring(0, 8).toUpperCase();
      await box.put('deviceId', id);
    }
    _deviceId = id;
  }

  // ── Scanning ──────────────────────────────────────────────────────────────

  Future<void> startScan() async {
    final adapterState = await FlutterBluePlus.adapterState.first;
    if (adapterState != BluetoothAdapterState.on) {
      _statusMessage = 'Bluetooth is off. Please enable it.';
      notifyListeners();
      return;
    }

    _nearbyPets.clear();
    _state = BleState.scanning;
    _statusMessage = 'Scanning for Navis nearby...';
    notifyListeners();

    await FlutterBluePlus.startScan(
      withServices: [Guid(PetBle.serviceUuid)],
      timeout: const Duration(seconds: 10),
    );

    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final existing = _nearbyPets.indexWhere(
            (p) => p.device.remoteId == r.device.remoteId);
        // Parse advertised name as "naviName|level"
        final parts = (r.advertisementData.advName).split('|');
        final naviName = parts.isNotEmpty ? parts[0] : r.device.remoteId.str;
        final naviLevel = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;

        final pet = DiscoveredPet(
          device: r.device,
          naviName: naviName,
          naviLevel: naviLevel,
          rssi: r.rssi,
        );

        if (existing >= 0) {
          _nearbyPets[existing] = pet;
        } else {
          _nearbyPets.add(pet);
        }
        notifyListeners();
      }
    });

    await Future.delayed(const Duration(seconds: 10));
    await stopScan();
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    _scanSub?.cancel();
    _state = _nearbyPets.isEmpty ? BleState.idle : BleState.idle;
    _statusMessage = _nearbyPets.isEmpty
        ? 'No Navis found. Try again!'
        : '${_nearbyPets.length} Navi(s) found nearby!';
    notifyListeners();
  }

  // ── Connection ────────────────────────────────────────────────────────────

  Future<void> connectTo(DiscoveredPet pet) async {
    _statusMessage = 'Connecting to ${pet.naviName}...';
    notifyListeners();

    try {
      await pet.device.connect(timeout: const Duration(seconds: 8));
      _connectedDevice = pet.device;
      _state = BleState.connected;
      _statusMessage = 'Connected to ${pet.naviName}!';

      await _discoverServices(pet.device);
      notifyListeners();
    } catch (e) {
      _statusMessage = 'Connection failed: $e';
      _state = BleState.idle;
      notifyListeners();
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (final s in services) {
      if (s.serviceUuid == Guid(PetBle.serviceUuid)) {
        for (final c in s.characteristics) {
          if (c.characteristicUuid == Guid(PetBle.txCharUuid)) {
            _txChar = c;
            await c.setNotifyValue(true);
            c.lastValueStream.listen(_onDataReceived);
          }
          if (c.characteristicUuid == Guid(PetBle.rxCharUuid)) {
            _rxChar = c;
          }
        }
      }
    }
  }

  void _onDataReceived(List<int> bytes) {
    try {
      final json = utf8.decode(bytes);
      final msg = jsonDecode(json) as Map<String, dynamic>;
      _messageController.add(msg);
    } catch (e) {
      debugPrint('[BLE] Received malformed data: $e');
    }
  }

  // ── Messaging ─────────────────────────────────────────────────────────────

  Future<void> sendMessage(Map<String, dynamic> payload) async {
    if (_rxChar == null) return;
    final bytes = utf8.encode(jsonEncode(payload));
    await _rxChar!.write(bytes, withoutResponse: true);
  }

  /// Send selected chip index in a PvP battle
  Future<void> sendChipSelection(int chipIndex) async {
    await sendMessage({'type': 'chip_select', 'chipIndex': chipIndex});
  }

  /// Send chip trade offer
  Future<void> sendTradeOffer(Map<String, dynamic> chipData) async {
    await sendMessage({'type': 'trade_offer', 'chip': chipData});
  }

  Future<void> disconnect() async {
    await _connectedDevice?.disconnect();
    _connectedDevice = null;
    _txChar = null;
    _rxChar = null;
    _state = BleState.idle;
    _statusMessage = 'Disconnected';
    notifyListeners();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _messageController.close();
    super.dispose();
  }
}
