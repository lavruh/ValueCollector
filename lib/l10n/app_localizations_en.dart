// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get meterGroups => 'Meter Groups';

  @override
  String get routes => 'Routes';

  @override
  String get reminders => 'Reminders';

  @override
  String get import => 'Import';

  @override
  String get export => 'Export';

  @override
  String get exportedTo => 'Exported to';

  @override
  String get name => 'Name';

  @override
  String get unit => 'Unit';

  @override
  String get correction => 'Correction';

  @override
  String get rawValue => 'Raw value';

  @override
  String get correctedValue => 'Corrected value';

  @override
  String get openRouteFile => 'Open route file';

  @override
  String get todo => 'Todo';

  @override
  String get done => 'Done';

  @override
  String get dayLetter => 'D';

  @override
  String get monthLetter => 'M';

  @override
  String get hourMinnute => 'h:m';

  @override
  String get repeat => 'Repeat';

  @override
  String get delete => 'Delete';

  @override
  String get deleteMsg => 'Are you sure to want delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get exportOptions => 'Export options';

  @override
  String get lastInCsv => 'Last values as CSV';

  @override
  String get bokaPdf => 'Boka running hours report';

  @override
  String get meterRates => 'Meter rates';

  @override
  String get limit => 'Limit';

  @override
  String get price => 'Price';

  @override
  String get pleaseEnterText => 'Please enter some text';

  @override
  String get incorrectLimit => 'Value should be positive integer';

  @override
  String get meterTypes => 'Meter types';

  @override
  String get diffCalc => 'Value difference';

  @override
  String get diffCalcDescr =>
      'Calculates value differences, values sorted by date';

  @override
  String get prodCostCalc1 => 'Meter production costs';

  @override
  String get prodCostDescr1 =>
      'Calculates meter production cost, counter value divided in limit ranges, each part multiplies by refereced price';

  @override
  String get prodCostMaxLimCalc => 'Meter production costs 2';

  @override
  String get prodCostMaxLimDescr =>
      'Calculates meter production cost, counter value times price of reached limit';

  @override
  String get inDays => 'in days';

  @override
  String get avaragePerDay => 'Average per day';

  @override
  String get reachedLimit => 'Reached limit is';

  @override
  String get reading => 'Reading';

  @override
  String get remarks => 'Remarks';

  @override
  String get warningReadingEmpty => 'Reading should not be empty';

  @override
  String get warningReadingIsNotInteger => 'Reading should be integer';
}
