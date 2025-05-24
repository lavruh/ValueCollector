// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get meterGroups => 'Групи лічільників';

  @override
  String get routes => 'Маршрути збору';

  @override
  String get reminders => 'Нагадування';

  @override
  String get import => 'Імпорт';

  @override
  String get export => 'Експорт';

  @override
  String get exportedTo => 'Експортовано в';

  @override
  String get name => 'Ім\'я';

  @override
  String get unit => 'Одиниця вимиру';

  @override
  String get correction => 'Коррекція';

  @override
  String get rawValue => 'Необроблене значення';

  @override
  String get correctedValue => 'Значення';

  @override
  String get openRouteFile => 'Відкрити файл з списком лічільників';

  @override
  String get todo => 'Зібрати';

  @override
  String get done => 'Зібрані';

  @override
  String get dayLetter => 'Д';

  @override
  String get monthLetter => 'M';

  @override
  String get hourMinnute => 'г:м';

  @override
  String get repeat => 'Повторити';

  @override
  String get delete => 'Видалити';

  @override
  String get deleteMsg => 'Ви дійсно бажаєте видалити';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get exportOptions => 'Опції експорту';

  @override
  String get lastInCsv => 'Останні показники в  CSV';

  @override
  String get bokaPdf => 'Boka running hours report';

  @override
  String get meterRates => 'Тарифи';

  @override
  String get limit => 'Ліміт';

  @override
  String get price => 'Ціна';

  @override
  String get pleaseEnterText => 'Введіть значення';

  @override
  String get incorrectLimit => 'Значення має бути позитивним цілим';

  @override
  String get meterTypes => 'Типи лічільників';

  @override
  String get diffCalc => 'Різниця значень';

  @override
  String get diffCalcDescr =>
      'Обчислюе різницю значень. значення сортуються за датою';

  @override
  String get prodCostCalc1 => 'Витрати з лімітами';

  @override
  String get prodCostDescr1 => 'Обчислюе сумму витрат за кожним лімітом';

  @override
  String get prodCostMaxLimCalc => 'Витрати з лімітами 2';

  @override
  String get prodCostMaxLimDescr =>
      'Обчислюе сумму витрат за досягнутим лімітом';

  @override
  String get inDays => 'за дні';

  @override
  String get avaragePerDay => 'В середньому за день';

  @override
  String get reachedLimit => 'Досягнутий ліміт';

  @override
  String get reading => 'Показник';

  @override
  String get remarks => 'Нотатки';

  @override
  String get warningReadingEmpty => 'Показник має бути заповнений';

  @override
  String get warningReadingIsNotInteger => 'Показник має бути цілим числом';
}
