// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Project PET - Advanced';

  @override
  String get navHome => 'STARTSEITE';

  @override
  String get navPetStatus => 'STATUS';

  @override
  String get navEvolution => 'ENTWICKLUNG';

  @override
  String get navChipBrowser => 'CHIPS';

  @override
  String get navBattle => 'KAMPF';

  @override
  String get navOnlineHub => 'ONLINE';

  @override
  String get navCollection => 'SAMMLUNG';

  @override
  String get navMissions => 'MISSIONEN';

  @override
  String get navSettings => 'EINSTELLUNGEN';

  @override
  String get navBle => 'BLE';

  @override
  String get screenStartTitle => 'STARTSEITE / HOME';

  @override
  String get screenStatusTitle => 'PET STATUS';

  @override
  String get screenEvolutionTitle => 'ENTWICKLUNG';

  @override
  String get screenChipBrowserTitle => 'CHIP ÜBERSICHT';

  @override
  String get screenChipDetailTitle => 'CHIP DETAILS';

  @override
  String get screenBattleLocalTitle => 'KAMPF (LOKAL)';

  @override
  String get screenBattleOnlineTitle => 'KAMPF (ONLINE)';

  @override
  String get screenOnlineHubTitle => 'ONLINE ZENTRUM';

  @override
  String get screenCollectionTitle => 'SAMMLUNG';

  @override
  String get screenMissionsTitle => 'MISSIONEN';

  @override
  String get screenSettingsTitle => 'EINSTELLUNGEN';

  @override
  String petStatusHp(int current, int max) {
    return 'KP: $current/$max';
  }

  @override
  String petStatusLevel(int level) {
    return 'Stufe: $level';
  }

  @override
  String petStatusExp(int current, int next) {
    return 'EXP: $current/$next';
  }

  @override
  String petStatusAttack(int value) {
    return 'ATTACKE: $value';
  }

  @override
  String petStatusRapid(int value) {
    return 'SCHNELL: $value';
  }

  @override
  String petStatusCharge(int value) {
    return 'LADUNG: $value';
  }

  @override
  String petStatusHunger(int value) {
    return 'HUNGER: $value%';
  }

  @override
  String petStatusHappiness(int value) {
    return 'FREUDE: $value%';
  }

  @override
  String get evolutionAvailable => 'ENTWICKLUNG VERFÜGBAR!';

  @override
  String get evolutionFormStandard => 'STANDARD';

  @override
  String get evolutionFormMega => 'MEGA';

  @override
  String get evolutionFormGiga => 'GIGA';

  @override
  String get chipBrowserAll => 'ALLE';

  @override
  String get chipBrowserAttack => 'ATTACKE';

  @override
  String get chipBrowserSupport => 'UNTERSTÜTZUNG';

  @override
  String get chipBrowserMega => 'MEGA';

  @override
  String get chipBrowserFilter => 'FILTER';

  @override
  String get chipBrowserSort => 'SORTIEREN';

  @override
  String get battleVsWild => 'GEGEN VIRUS';

  @override
  String battleVsOpponent(String name) {
    return 'GEGEN $name';
  }

  @override
  String get battleVictory => 'SIEG!';

  @override
  String get battleDefeat => 'NIEDERLAGE...';

  @override
  String get battleReturn => 'ZUR STARTSEITE';

  @override
  String collectionTotal(int count, int max) {
    return 'GESAMT: $count/$max';
  }

  @override
  String get missionsAvailable => 'VERFÜGBAR';

  @override
  String get missionsCompleted => 'ABGESCHLOSSEN';

  @override
  String get settingsLanguage => 'SPRACHE';

  @override
  String get settingsTheme => 'DESIGN';

  @override
  String get settingsThemeBlue => 'KLASSISCHES BLAU';

  @override
  String get settingsThemeRed => 'ROT';

  @override
  String get settingsThemeBlack => 'SCHWARZ';

  @override
  String get settingsThemeGreen => 'GRÜN';

  @override
  String get settingsThemeYellow => 'GELB';

  @override
  String get commonYes => 'JA';

  @override
  String get commonNo => 'NEIN';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'ABBRECHEN';

  @override
  String get commonConfirm => 'BESTÄTIGEN';

  @override
  String get commonBack => 'ZURÜCK';

  @override
  String homeSteps(int count) {
    return '$count SCHRITTE';
  }

  @override
  String homeZenny(int amount) {
    return 'ZENNY: $amount';
  }

  @override
  String homeWins(int count) {
    return 'SIEGE: $count';
  }

  @override
  String homeLosses(int count) {
    return 'NIEDERLAGEN: $count';
  }

  @override
  String get virusAlertTitle => '⚠️ VIRUSWARNUNG';

  @override
  String get virusAlertMessage => 'EIN VIRUS ERSCHIEN!';

  @override
  String get virusAlertFlee => 'FLIEHEN';

  @override
  String get virusAlertBattle => 'KAMPF!';

  @override
  String get bleRadarRing => 'JACK IN';

  @override
  String get bleTitle => 'BLE RADAR';

  @override
  String get bleScan => 'SCANNEN';

  @override
  String bleStatus(String status) {
    return 'Status: $status';
  }

  @override
  String get bleNavisFound => 'Gefundene Navis:';

  @override
  String get bleConnect => 'Verbinden';

  @override
  String get bleScanning => 'SCANNE...';

  @override
  String get bleScanForNavis => 'SCANNE NAVIS';

  @override
  String get bleNavisDetected => 'NAVIS ERKANNT';

  @override
  String get bleDisc => 'ENTDECKT';

  @override
  String get combatVirusEncounter => 'VIRENBEGENUNG';

  @override
  String get combatPvP => 'PVP KAMPF';

  @override
  String get combatHp => 'KP';

  @override
  String combatStatus(String status) {
    return 'STATUS: $status';
  }

  @override
  String get combatFlee => 'FLIEHEN';

  @override
  String get combatSendChip => 'CHIP SENDEN';

  @override
  String get combatSlash => '>> SCHNITT! <<';

  @override
  String get combatWaiting => 'WARTE AUF GEGNER...';

  @override
  String get combatSelectChip => 'CHIP WÄHLEN';

  @override
  String get combatShake => 'HANDY SCHÜTTELN ODER';

  @override
  String get combatAwesome => 'FANTASTISCH!';

  @override
  String get combatRetreat => 'RÜCKZUG';

  @override
  String combatGotData(int zenny, String chip) {
    return 'Erhalten ${zenny}z und $chip!';
  }

  @override
  String get chipFolderTitle => 'CHIP MAPPE';

  @override
  String get chipFolderEmpty => 'Deine Mappe ist leer.';

  @override
  String chipDmg(int damage) {
    return 'SCHAD: $damage';
  }

  @override
  String get onboardingTitle => 'WILLKOMMEN';

  @override
  String get onboardingSubtitle => 'Erstelle deinen Navi';

  @override
  String get onboardingYes => 'JA';

  @override
  String get onboardingNo => 'NEIN';

  @override
  String get onboardingConfirm => 'BESTÄTIGEN';

  @override
  String get combatVictory => 'SIEG!';

  @override
  String get combatDefeat => 'NIEDERLAGE...';

  @override
  String get chipFolderRarity => 'SELTENHEIT';

  @override
  String get chipFolderAll => 'ALLE';

  @override
  String get chipFolderNoChips => 'Keine Chips';

  @override
  String get chipFolderDiscard => 'VERWERFEN';

  @override
  String get chipFolderKeep => 'BEHALTEN';

  @override
  String get homeCyberMeter => 'CYBER METER';

  @override
  String homeStepsToEncounter(int steps) {
    return 'Schritte bis Begegnung: $steps';
  }

  @override
  String get homeBattleVirus => 'VIRUS KAMPF';

  @override
  String get homeJackIn => 'JACK IN';

  @override
  String get homeDebug => 'DEBUG';

  @override
  String get navChips => 'CHIPS';

  @override
  String get chipBrowserNoChips => 'Keine Chips';

  @override
  String get onlineRankedMatch => 'RANKED KAMPF';

  @override
  String get onlineCasualMatch => 'CASUAL KAMPF';

  @override
  String get onlineLeaderboards => 'BESTENLISTEN';

  @override
  String collectionProgress(int percent) {
    return '$percent%';
  }

  @override
  String get settingsProfile => 'PROFIL';
}
