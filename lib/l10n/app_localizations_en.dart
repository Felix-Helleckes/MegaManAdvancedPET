// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Project PET';

  @override
  String get homeCyberMeter => 'CYBER METER';

  @override
  String homeSteps(int count) {
    return '$count steps';
  }

  @override
  String homeStepsToEncounter(int count) {
    return '$count steps to next encounter';
  }

  @override
  String get homeZenny => 'ZENNY';

  @override
  String get homeWins => 'WINS';

  @override
  String get homeLosses => 'LOSSES';

  @override
  String get homeBattleVirus => 'BATTLE VIRUS';

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
  String get virusAlertTitle => '⚠️ VIRUS ALERT';

  @override
  String get virusAlertMessage => 'A virus appeared!\nReady to battle?';

  @override
  String get virusAlertFlee => 'FLEE';

  @override
  String get virusAlertBattle => 'BATTLE!';

  @override
  String get onboardingTitle => 'SELECT YOUR NETNAVI';

  @override
  String get onboardingSubtitle =>
      'Choose your partner for the cyber world. This choice is permanent.';

  @override
  String onboardingConfirm(String name) {
    return 'CONFIRM $name?';
  }

  @override
  String get onboardingYes => 'YES';

  @override
  String get onboardingNo => 'NO';

  @override
  String get combatVirusEncounter => 'VIRUS ENCOUNTER';

  @override
  String get combatPvP => 'PVP BATTLE';

  @override
  String get combatHp => 'HP';

  @override
  String combatStatus(String status) {
    return 'STATUS: $status';
  }

  @override
  String get combatFlee => 'FLEE';

  @override
  String get combatSendChip => 'SEND CHIP';

  @override
  String get combatSlash => '>> SLASH! <<';

  @override
  String get combatWaiting => 'WAITING FOR OPPONENT...';

  @override
  String get combatVictory => 'VICTORY!';

  @override
  String get combatDefeat => 'DEFEAT...';

  @override
  String get combatReturn => 'RETURN';

  @override
  String combatGotData(int zenny, String chip) {
    return 'Got ${zenny}z and $chip!';
  }

  @override
  String get combatSelectChip => 'SELECT CHIP';

  @override
  String get combatShake => 'SHAKE PHONE OR';

  @override
  String get combatAwesome => 'AWESOME!';

  @override
  String get combatRetreat => 'RETREAT';

  @override
  String get bleTitle => 'BLE RADAR';

  @override
  String get bleScan => 'SCAN';

  @override
  String bleStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get bleNavisFound => 'Found Navis:';

  @override
  String get bleConnect => 'Connect';

  @override
  String get bleRadarRing => 'JACK IN';

  @override
  String get bleScanning => 'SCANNING...';

  @override
  String get bleScanForNavis => 'SCAN FOR NAVIS';

  @override
  String get bleNavisDetected => 'NAVIS DETECTED';

  @override
  String get bleDisc => 'DISC.';

  @override
  String get chipFolderTitle => 'CHIP FOLDER';

  @override
  String get chipFolderEmpty => 'Your folder is empty.';

  @override
  String chipDmg(int damage) {
    return 'DMG: $damage';
  }

  @override
  String get chipFolderAll => 'ALL';

  @override
  String get chipFolderRarity => 'RARITY: ';

  @override
  String get chipFolderNoChips => 'NO CHIPS';

  @override
  String get chipFolderDiscard => 'DISCARD';

  @override
  String get chipFolderKeep => 'KEEP';
}
