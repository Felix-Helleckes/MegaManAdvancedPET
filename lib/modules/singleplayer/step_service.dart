import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

/// Handles background step counting and virus encounter triggers.
/// Steps are persisted in Hive so they survive app restarts.
class StepService {
  static const int stepsPerEncounter = 2000;
  static const String _boxKey = 'totalSteps';
  static const String _lastTriggerKey = 'lastTriggerSteps';

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static StreamSubscription<StepCount>? _stepSub;
  static StreamSubscription<PedestrianStatus>? _statusSub;
  static Timer? _simTimer;

  // Broadcast so multiple listeners (UI + service) can subscribe
  static final StreamController<int> _stepController =
      StreamController<int>.broadcast();

  static Stream<int> get stepStream => _stepController.stream;

  static int _currentSteps = 0;
  static int get currentSteps => _currentSteps;

  // Callback invoked when a virus encounter should be triggered
  static VoidCallback? onEncounterTriggered;

  static Future<void> initialize() async {
    // Restore persisted steps
    final box = Hive.box('settings');
    _currentSteps = box.get(_boxKey, defaultValue: 0) as int;

    // Init local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: false,
      requestSoundPermission: true,
    );
    await _notifications.initialize(
      const InitializationSettings(
          android: androidSettings, iOS: iosSettings),
    );

    // On platforms without pedometer implementation (web/desktop), start simulation.
    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      debugPrint('[StepService] Pedometer not supported on this platform, starting simulation');
      _startSimulation();
      return;
    }

    // Try to start real pedometer listening; if it fails, fall back to simulation.
    try {
      _startListening();
    } catch (e) {
      debugPrint('[StepService] Pedometer init failed, starting simulation: $e');
      _startSimulation();
    }
  }

  static void _startListening() {
    _stepSub = Pedometer.stepCountStream.listen(
      _onStep,
      onError: (e) => debugPrint('[StepService] stepCountStream error: $e'),
      cancelOnError: false,
    );

    _statusSub = Pedometer.pedestrianStatusStream.listen(
      (status) => debugPrint('[StepService] status: ${status.status}'),
      onError: (e) => debugPrint('[StepService] status error: $e'),
      cancelOnError: false,
    );
  }

  // Simple simulation for emulator/testing: increments steps every second.
  static void _startSimulation() {
    _simTimer?.cancel();
    _simTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      addSimulatedSteps(1);
    });
  }

  static void _onStep(StepCount event) {
    // The pedometer reports absolute steps since boot; we accumulate deltas.
    // On first call we just record the baseline.
    final box = Hive.box('settings');
    final baseline = box.get('stepBaseline', defaultValue: -1) as int;

    if (baseline < 0) {
      box.put('stepBaseline', event.steps);
      return;
    }

    final delta = event.steps - baseline;
    if (delta < 0) {
      // Device rebooted, reset baseline
      box.put('stepBaseline', event.steps);
      return;
    }

    _currentSteps = (box.get(_boxKey, defaultValue: 0) as int) + delta;
    box.put(_boxKey, _currentSteps);
    box.put('stepBaseline', event.steps);

    _stepController.add(_currentSteps);

    _checkEncounterTrigger();
  }

  static void _checkEncounterTrigger() {
    final box = Hive.box('settings');
    final lastTrigger = box.get(_lastTriggerKey, defaultValue: 0) as int;

    if (_currentSteps - lastTrigger >= stepsPerEncounter) {
      box.put(_lastTriggerKey, _currentSteps);
      _sendVirusNotification();
      onEncounterTriggered?.call();
    }
  }

  static Future<void> _sendVirusNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'virus_alert',
      'Virus Alert',
      channelDescription: 'Notifies when a virus encounter is ready.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    await _notifications.show(
      0,
      '⚠️ VIRUS DETECTED',
      'A virus appeared! Open PET to battle.',
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  /// Add steps manually (for testing / shaking gesture)
  static void addSimulatedSteps(int count) {
    final box = Hive.box('settings');
    _currentSteps += count;
    box.put(_boxKey, _currentSteps);
    _stepController.add(_currentSteps);
    _checkEncounterTrigger();
  }

  static void dispose() {
    _stepSub?.cancel();
    _statusSub?.cancel();
    _simTimer?.cancel();
    _stepController.close();
  }
}
