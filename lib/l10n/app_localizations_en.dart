// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Project PET - Advanced';

  @override
  String get navHome => 'HOME';

  @override
  String get navPetStatus => 'STATUS';

  @override
  String get navEvolution => 'EVOLUTION';

  @override
  String get navChipBrowser => 'CHIPS';

  @override
  String get navBattle => 'BATTLE';

  @override
  String get navOnlineHub => 'ONLINE';

  @override
  String get navCollection => 'LIBRARY';

  @override
  String get navMissions => 'MISSIONS';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String get navBle => 'BLE';

  @override
  String get screenStartTitle => 'START / HOME';

  @override
  String get screenStatusTitle => 'PET STATUS';

  @override
  String get screenEvolutionTitle => 'EVOLUTION';

  @override
  String get screenChipBrowserTitle => 'CHIP BROWSER';

  @override
  String get screenChipDetailTitle => 'CHIP DETAIL';

  @override
  String get screenBattleLocalTitle => 'BATTLE (LOCAL)';

  @override
  String get screenBattleOnlineTitle => 'BATTLE (ONLINE)';

  @override
  String get screenOnlineHubTitle => 'ONLINE HUB';

  @override
  String get screenCollectionTitle => 'COLLECTION';

  @override
  String get screenMissionsTitle => 'MISSIONS';

  @override
  String get screenSettingsTitle => 'SETTINGS';

  @override
  String petStatusHp(int current, int max) {
    return 'HP: $current/$max';
  }

  @override
  String petStatusLevel(int level) {
    return 'Level: $level';
  }

  @override
  String petStatusExp(int current, int next) {
    return 'EXP: $current/$next';
  }

  @override
  String petStatusAttack(int value) {
    return 'ATTACK: $value';
  }

  @override
  String petStatusRapid(int value) {
    return 'RAPID: $value';
  }

  @override
  String petStatusCharge(int value) {
    return 'CHARGE: $value';
  }

  @override
  String petStatusHunger(int value) {
    return 'HUNGER: $value%';
  }

  @override
  String petStatusHappiness(int value) {
    return 'HAPPINESS: $value%';
  }

  @override
  String get evolutionAvailable => 'EVOLUTION AVAILABLE!';

  @override
  String get evolutionFormStandard => 'STANDARD';

  @override
  String get evolutionFormMega => 'MEGA';

  @override
  String get evolutionFormGiga => 'GIGA';

  @override
  String get chipBrowserAll => 'ALL';

  @override
  String get chipBrowserAttack => 'ATTACK';

  @override
  String get chipBrowserSupport => 'SUPPORT';

  @override
  String get chipBrowserMega => 'MEGA';

  @override
  String get chipBrowserFilter => 'FILTER';

  @override
  String get chipBrowserSort => 'SORT';

  @override
  String get battleVsWild => 'VS VIRUS';

  @override
  String battleVsOpponent(String name) {
    return 'VS $name';
  }

  @override
  String get battleVictory => 'VICTORY!';

  @override
  String get battleDefeat => 'DEFEAT...';

  @override
  String get battleReturn => 'RETURN HOME';

  @override
  String collectionTotal(int count, int max) {
    return 'TOTAL: $count/$max';
  }

  @override
  String get missionsAvailable => 'AVAILABLE';

  @override
  String get missionsCompleted => 'COMPLETED';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get settingsTheme => 'THEME';

  @override
  String get settingsThemeBlue => 'CLASSIC BLUE';

  @override
  String get settingsThemeRed => 'RED';

  @override
  String get settingsThemeBlack => 'BLACK';

  @override
  String get settingsThemeGreen => 'GREEN';

  @override
  String get settingsThemeYellow => 'YELLOW';

  @override
  String get commonYes => 'YES';

  @override
  String get commonNo => 'NO';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'CANCEL';

  @override
  String get commonConfirm => 'CONFIRM';

  @override
  String get commonBack => 'BACK';

  @override
  String homeSteps(int count) {
    return '$count STEPS';
  }

  @override
  String homeZenny(int amount) {
    return 'ZENNY: $amount';
  }

  @override
  String homeWins(int count) {
    return 'WINS: $count';
  }

  @override
  String homeLosses(int count) {
    return 'LOSSES: $count';
  }

  @override
  String get virusAlertTitle => '⚠️ VIRUS ALERT';

  @override
  String get virusAlertMessage => 'A VIRUS APPEARED!';

  @override
  String get virusAlertFlee => 'FLEE';

  @override
  String get virusAlertBattle => 'BATTLE!';

  @override
  String get bleRadarRing => 'JACK IN';

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
  String get bleScanning => 'SCANNING...';

  @override
  String get bleScanForNavis => 'SCAN FOR NAVIS';

  @override
  String get bleNavisDetected => 'NAVIS DETECTED';

  @override
  String get bleDisc => 'DISC.';

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
  String get combatSelectChip => 'SELECT CHIP';

  @override
  String get combatShake => 'SHAKE PHONE OR';

  @override
  String get combatAwesome => 'AWESOME!';

  @override
  String get combatRetreat => 'RETREAT';

  @override
  String combatGotData(int zenny, String chip) {
    return 'Got ${zenny}z and $chip!';
  }

  @override
  String get chipFolderTitle => 'CHIP FOLDER';

  @override
  String get chipFolderEmpty => 'Your folder is empty.';

  @override
  String chipDmg(int damage) {
    return 'DMG: $damage';
  }

  @override
  String get onboardingTitle => 'WELCOME';

  @override
  String get onboardingSubtitle => 'Create your Navi';

  @override
  String get onboardingYes => 'YES';

  @override
  String get onboardingNo => 'NO';

  @override
  String get onboardingConfirm => 'CONFIRM';

  @override
  String get combatVictory => 'VICTORY!';

  @override
  String get combatDefeat => 'DEFEAT...';

  @override
  String get chipFolderRarity => 'RARITY';

  @override
  String get chipFolderAll => 'ALL';

  @override
  String get chipFolderNoChips => 'No chips';

  @override
  String get chipFolderDiscard => 'DISCARD';

  @override
  String get chipFolderKeep => 'KEEP';

  @override
  String get homeCyberMeter => 'CYBER METER';

  @override
  String homeStepsToEncounter(int steps) {
    return 'Steps to Encounter: $steps';
  }

  @override
  String get homeBattleVirus => 'BATTLE VIRUS';

  @override
  String get homeJackIn => 'JACK IN';

  @override
  String get homeDebug => 'DEBUG';

  @override
  String get navChips => 'CHIPS';

  @override
  String get chipBrowserNoChips => 'No chips';

  @override
  String get onlineRankedMatch => 'RANKED MATCH';

  @override
  String get onlineCasualMatch => 'CASUAL MATCH';

  @override
  String get onlineLeaderboards => 'LEADERBOARDS';

  @override
  String collectionProgress(int percent) {
    return '$percent%';
  }

  @override
  String get settingsProfile => 'PROFILE';
}
