// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get welcomeMessage => 'Welcome to the app';

  @override
  String get wallet => 'My Wallet';

  @override
  String get balance => 'Balance';

  @override
  String get noTransactions => 'No Transaction yet';

  @override
  String get navHome => 'Home';

  @override
  String get navFilters => 'Filters';

  @override
  String get navStats => 'Stats';

  @override
  String get navHistory => 'History';

  @override
  String get insufficientFunds => 'Insufficient funds for this transaction!';

  @override
  String get usdCurrency => 'USD currency:';

  @override
  String get fetchingCurrency => 'Fetching currency..';

  @override
  String get available => 'Available: ';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';
}
