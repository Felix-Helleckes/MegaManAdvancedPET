import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Project PET'**
  String get appTitle;

  /// No description provided for @homeCyberMeter.
  ///
  /// In en, this message translates to:
  /// **'CYBER METER'**
  String get homeCyberMeter;

  /// No description provided for @homeSteps.
  ///
  /// In en, this message translates to:
  /// **'{count} steps'**
  String homeSteps(int count);

  /// No description provided for @homeStepsToEncounter.
  ///
  /// In en, this message translates to:
  /// **'{count} steps to next encounter'**
  String homeStepsToEncounter(int count);

  /// No description provided for @homeZenny.
  ///
  /// In en, this message translates to:
  /// **'ZENNY'**
  String get homeZenny;

  /// No description provided for @homeWins.
  ///
  /// In en, this message translates to:
  /// **'WINS'**
  String get homeWins;

  /// No description provided for @homeLosses.
  ///
  /// In en, this message translates to:
  /// **'LOSSES'**
  String get homeLosses;

  /// No description provided for @homeBattleVirus.
  ///
  /// In en, this message translates to:
  /// **'BATTLE VIRUS'**
  String get homeBattleVirus;

  /// No description provided for @homeJackIn.
  ///
  /// In en, this message translates to:
  /// **'JACK IN  [ BLE ]'**
  String get homeJackIn;

  /// No description provided for @homeDebug.
  ///
  /// In en, this message translates to:
  /// **'DEBUG'**
  String get homeDebug;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get navHome;

  /// No description provided for @navChips.
  ///
  /// In en, this message translates to:
  /// **'CHIPS'**
  String get navChips;

  /// No description provided for @navBle.
  ///
  /// In en, this message translates to:
  /// **'BLE'**
  String get navBle;

  /// No description provided for @virusAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'⚠️ VIRUS ALERT'**
  String get virusAlertTitle;

  /// No description provided for @virusAlertMessage.
  ///
  /// In en, this message translates to:
  /// **'A virus appeared!\nReady to battle?'**
  String get virusAlertMessage;

  /// No description provided for @virusAlertFlee.
  ///
  /// In en, this message translates to:
  /// **'FLEE'**
  String get virusAlertFlee;

  /// No description provided for @virusAlertBattle.
  ///
  /// In en, this message translates to:
  /// **'BATTLE!'**
  String get virusAlertBattle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'SELECT YOUR NETNAVI'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your partner for the cyber world. This choice is permanent.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingConfirm.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM {name}?'**
  String onboardingConfirm(String name);

  /// No description provided for @onboardingYes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get onboardingYes;

  /// No description provided for @onboardingNo.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get onboardingNo;

  /// No description provided for @combatVirusEncounter.
  ///
  /// In en, this message translates to:
  /// **'VIRUS ENCOUNTER'**
  String get combatVirusEncounter;

  /// No description provided for @combatPvP.
  ///
  /// In en, this message translates to:
  /// **'PVP BATTLE'**
  String get combatPvP;

  /// No description provided for @combatHp.
  ///
  /// In en, this message translates to:
  /// **'HP'**
  String get combatHp;

  /// No description provided for @combatStatus.
  ///
  /// In en, this message translates to:
  /// **'STATUS: {status}'**
  String combatStatus(String status);

  /// No description provided for @combatFlee.
  ///
  /// In en, this message translates to:
  /// **'FLEE'**
  String get combatFlee;

  /// No description provided for @combatSendChip.
  ///
  /// In en, this message translates to:
  /// **'SEND CHIP'**
  String get combatSendChip;

  /// No description provided for @combatSlash.
  ///
  /// In en, this message translates to:
  /// **'>> SLASH! <<'**
  String get combatSlash;

  /// No description provided for @combatWaiting.
  ///
  /// In en, this message translates to:
  /// **'WAITING FOR OPPONENT...'**
  String get combatWaiting;

  /// No description provided for @combatVictory.
  ///
  /// In en, this message translates to:
  /// **'VICTORY!'**
  String get combatVictory;

  /// No description provided for @combatDefeat.
  ///
  /// In en, this message translates to:
  /// **'DEFEAT...'**
  String get combatDefeat;

  /// No description provided for @combatReturn.
  ///
  /// In en, this message translates to:
  /// **'RETURN'**
  String get combatReturn;

  /// No description provided for @combatGotData.
  ///
  /// In en, this message translates to:
  /// **'Got {zenny}z and {chip}!'**
  String combatGotData(int zenny, String chip);

  /// No description provided for @combatSelectChip.
  ///
  /// In en, this message translates to:
  /// **'SELECT CHIP'**
  String get combatSelectChip;

  /// No description provided for @combatShake.
  ///
  /// In en, this message translates to:
  /// **'SHAKE PHONE OR'**
  String get combatShake;

  /// No description provided for @combatAwesome.
  ///
  /// In en, this message translates to:
  /// **'AWESOME!'**
  String get combatAwesome;

  /// No description provided for @combatRetreat.
  ///
  /// In en, this message translates to:
  /// **'RETREAT'**
  String get combatRetreat;

  /// No description provided for @bleTitle.
  ///
  /// In en, this message translates to:
  /// **'BLE RADAR'**
  String get bleTitle;

  /// No description provided for @bleScan.
  ///
  /// In en, this message translates to:
  /// **'SCAN'**
  String get bleScan;

  /// No description provided for @bleStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String bleStatus(String status);

  /// No description provided for @bleNavisFound.
  ///
  /// In en, this message translates to:
  /// **'Found Navis:'**
  String get bleNavisFound;

  /// No description provided for @bleConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get bleConnect;

  /// No description provided for @bleRadarRing.
  ///
  /// In en, this message translates to:
  /// **'JACK IN'**
  String get bleRadarRing;

  /// No description provided for @bleScanning.
  ///
  /// In en, this message translates to:
  /// **'SCANNING...'**
  String get bleScanning;

  /// No description provided for @bleScanForNavis.
  ///
  /// In en, this message translates to:
  /// **'SCAN FOR NAVIS'**
  String get bleScanForNavis;

  /// No description provided for @bleNavisDetected.
  ///
  /// In en, this message translates to:
  /// **'NAVIS DETECTED'**
  String get bleNavisDetected;

  /// No description provided for @bleDisc.
  ///
  /// In en, this message translates to:
  /// **'DISC.'**
  String get bleDisc;

  /// No description provided for @chipFolderTitle.
  ///
  /// In en, this message translates to:
  /// **'CHIP FOLDER'**
  String get chipFolderTitle;

  /// No description provided for @chipFolderEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your folder is empty.'**
  String get chipFolderEmpty;

  /// No description provided for @chipDmg.
  ///
  /// In en, this message translates to:
  /// **'DMG: {damage}'**
  String chipDmg(int damage);

  /// No description provided for @chipFolderAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get chipFolderAll;

  /// No description provided for @chipFolderRarity.
  ///
  /// In en, this message translates to:
  /// **'RARITY: '**
  String get chipFolderRarity;

  /// No description provided for @chipFolderNoChips.
  ///
  /// In en, this message translates to:
  /// **'NO CHIPS'**
  String get chipFolderNoChips;

  /// No description provided for @chipFolderDiscard.
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get chipFolderDiscard;

  /// No description provided for @chipFolderKeep.
  ///
  /// In en, this message translates to:
  /// **'KEEP'**
  String get chipFolderKeep;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
