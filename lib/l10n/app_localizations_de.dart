// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Project PET';

  @override
  String get homeCyberMeter => 'CYBER-METER';

  @override
  String homeSteps(int count) {
    return '$count Schritte';
  }

  @override
  String homeStepsToEncounter(int count) {
    return '$count Schritte bis zum Kampf';
  }

  @override
  String get homeZenny => 'ZENNY';

  @override
  String get homeWins => 'SIEGE';

  @override
  String get homeLosses => 'NIEDERL.';

  @override
  String get homeBattleVirus => 'VIRENKAMPF';

  @override
  String get homeJackIn => 'JACK IN  [ BLE ]';

  @override
  String get homeDebug => 'DEBUG';

  @override
  String get navHome => 'HOME';

  @override
  String get navChips => 'CHIPS';

  @override
  String get navBle => 'BLE';

  @override
  String get virusAlertTitle => '⚠️ VIREN-ALARM';

  @override
  String get virusAlertMessage =>
      'Ein Virus ist aufgetaucht!\nBereit zum Kampf?';

  @override
  String get virusAlertFlee => 'FLUCHT';

  @override
  String get virusAlertBattle => 'KAMPF!';

  @override
  String get onboardingTitle => 'WÄHLE DEINEN NETNAVI';

  @override
  String get onboardingSubtitle =>
      'Wähle deinen Partner für die Cyber-Welt. Diese Wahl ist endgültig.';

  @override
  String onboardingConfirm(String name) {
    return '$name BESTÄTIGEN?';
  }

  @override
  String get onboardingYes => 'JA';

  @override
  String get onboardingNo => 'NEIN';

  @override
  String get combatVirusEncounter => 'VIREN-BEGEGNUNG';

  @override
  String get combatPvP => 'PVP-KAMPF';

  @override
  String get combatHp => 'TP';

  @override
  String combatStatus(String status) {
    return 'STATUS: $status';
  }

  @override
  String get combatFlee => 'FLUCHT';

  @override
  String get combatSendChip => 'CHIP SENDEN';

  @override
  String get combatSlash => '>> ANGRIFF! <<';

  @override
  String get combatWaiting => 'WARTE AUF GEGNER...';

  @override
  String get combatVictory => 'SIEG!';

  @override
  String get combatDefeat => 'NIEDERLAGE...';

  @override
  String get combatReturn => 'ZURÜCK';

  @override
  String combatGotData(int zenny, String chip) {
    return 'Erhalten: ${zenny}z und $chip!';
  }

  @override
  String get combatSelectChip => 'CHIP WÄHLEN';

  @override
  String get combatShake => 'GERÄT SCHÜTTELN ODER';

  @override
  String get combatAwesome => 'KLASSE!';

  @override
  String get combatRetreat => 'RÜCKZUG';

  @override
  String get bleTitle => 'BLE-RADAR';

  @override
  String get bleScan => 'SUCHEN';

  @override
  String bleStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get bleNavisFound => 'Gefundene Navis:';

  @override
  String get bleConnect => 'Verbinden';

  @override
  String get bleRadarRing => 'JACK IN';

  @override
  String get bleScanning => 'SUCHE...';

  @override
  String get bleScanForNavis => 'NAVIS SUCHEN';

  @override
  String get bleNavisDetected => 'NAVIS ERKANNT';

  @override
  String get bleDisc => 'TRENNEN';

  @override
  String get chipFolderTitle => 'CHIP-ORDNER';

  @override
  String get chipFolderEmpty => 'Dein Ordner ist leer.';

  @override
  String chipDmg(int damage) {
    return 'SCHDN: $damage';
  }

  @override
  String get chipFolderAll => 'ALLE';

  @override
  String get chipFolderRarity => 'SELTENHEIT: ';

  @override
  String get chipFolderNoChips => 'KEINE CHIPS';

  @override
  String get chipFolderDiscard => 'WEGWERFEN';

  @override
  String get chipFolderKeep => 'BEHALTEN';
}
