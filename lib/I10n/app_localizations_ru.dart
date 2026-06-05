// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get helloWorld => 'Привет, мир!';

  @override
  String get welcomeMessage => 'Добро пожаловать в приложение';

  @override
  String get wallet => 'Мой кошелек';

  @override
  String get balance => 'Баланс';

  @override
  String get noTransactions => 'Нет транзакций';

  @override
  String get navHome => 'Главная';

  @override
  String get navFilters => 'Фильтры';

  @override
  String get navStats => 'Статистика';

  @override
  String get navHistory => 'История';

  @override
  String get insufficientFunds =>
      'Недостаточно средств для совершения транзакции!';

  @override
  String get usdCurrency => 'Курс доллара:';

  @override
  String get fetchingCurrency => 'Загрузка курса доллара...';

  @override
  String get available => 'Доступно: ';

  @override
  String get expense => 'Расход';

  @override
  String get income => 'Доход';
}
