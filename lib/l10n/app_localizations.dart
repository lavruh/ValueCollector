import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_uk.dart';

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
    Locale('en'),
    Locale('uk')
  ];

  /// No description provided for @meterGroups.
  ///
  /// In en, this message translates to:
  /// **'Meter Groups'**
  String get meterGroups;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routes;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @exportedTo.
  ///
  /// In en, this message translates to:
  /// **'Exported to'**
  String get exportedTo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @correction.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get correction;

  /// No description provided for @rawValue.
  ///
  /// In en, this message translates to:
  /// **'Raw value'**
  String get rawValue;

  /// No description provided for @correctedValue.
  ///
  /// In en, this message translates to:
  /// **'Corrected value'**
  String get correctedValue;

  /// No description provided for @openRouteFile.
  ///
  /// In en, this message translates to:
  /// **'Open route file'**
  String get openRouteFile;

  /// No description provided for @todo.
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get todo;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @dayLetter.
  ///
  /// In en, this message translates to:
  /// **'D'**
  String get dayLetter;

  /// No description provided for @monthLetter.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get monthLetter;

  /// No description provided for @hourMinnute.
  ///
  /// In en, this message translates to:
  /// **'h:m'**
  String get hourMinnute;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteMsg.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to want delete'**
  String get deleteMsg;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @exportOptions.
  ///
  /// In en, this message translates to:
  /// **'Export options'**
  String get exportOptions;

  /// No description provided for @lastInCsv.
  ///
  /// In en, this message translates to:
  /// **'Last values as CSV'**
  String get lastInCsv;

  /// No description provided for @bokaPdf.
  ///
  /// In en, this message translates to:
  /// **'Boka running hours report'**
  String get bokaPdf;

  /// No description provided for @meterRates.
  ///
  /// In en, this message translates to:
  /// **'Meter rates'**
  String get meterRates;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @pleaseEnterText.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text'**
  String get pleaseEnterText;

  /// No description provided for @incorrectLimit.
  ///
  /// In en, this message translates to:
  /// **'Value should be positive integer'**
  String get incorrectLimit;

  /// No description provided for @meterTypes.
  ///
  /// In en, this message translates to:
  /// **'Meter types'**
  String get meterTypes;

  /// No description provided for @diffCalc.
  ///
  /// In en, this message translates to:
  /// **'Value difference'**
  String get diffCalc;

  /// No description provided for @diffCalcDescr.
  ///
  /// In en, this message translates to:
  /// **'Calculates value differences, values sorted by date'**
  String get diffCalcDescr;

  /// No description provided for @prodCostCalc1.
  ///
  /// In en, this message translates to:
  /// **'Meter production costs'**
  String get prodCostCalc1;

  /// No description provided for @prodCostDescr1.
  ///
  /// In en, this message translates to:
  /// **'Calculates meter production cost, counter value divided in limit ranges, each part multiplies by refereced price'**
  String get prodCostDescr1;

  /// No description provided for @prodCostMaxLimCalc.
  ///
  /// In en, this message translates to:
  /// **'Meter production costs 2'**
  String get prodCostMaxLimCalc;

  /// No description provided for @prodCostMaxLimDescr.
  ///
  /// In en, this message translates to:
  /// **'Calculates meter production cost, counter value times price of reached limit'**
  String get prodCostMaxLimDescr;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'in days'**
  String get inDays;

  /// No description provided for @avaragePerDay.
  ///
  /// In en, this message translates to:
  /// **'Average per day'**
  String get avaragePerDay;

  /// No description provided for @reachedLimit.
  ///
  /// In en, this message translates to:
  /// **'Reached limit is'**
  String get reachedLimit;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @warningReadingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Reading should not be empty'**
  String get warningReadingEmpty;

  /// No description provided for @warningReadingIsNotInteger.
  ///
  /// In en, this message translates to:
  /// **'Reading should be integer'**
  String get warningReadingIsNotInteger;

  /// No description provided for @incorrectFormula.
  ///
  /// In en, this message translates to:
  /// **'Incorrect formula'**
  String get incorrectFormula;

  /// No description provided for @formula.
  ///
  /// In en, this message translates to:
  /// **'Formula'**
  String get formula;

  /// No description provided for @lastValueSign.
  ///
  /// In en, this message translates to:
  /// **'n - is last value'**
  String get lastValueSign;

  /// No description provided for @inputNumber.
  ///
  /// In en, this message translates to:
  /// **'Input number'**
  String get inputNumber;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;
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
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
