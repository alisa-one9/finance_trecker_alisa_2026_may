import 'package:finance_trecker_alisa/river_states/currencyProvider.dart';
import 'package:finance_trecker_alisa/river_states/local_sum_provider.dart';
import 'package:finance_trecker_alisa/services/privacy_service.dart';
import 'package:finance_trecker_alisa/services/settings_service.dart';
import 'package:finance_trecker_alisa/services/theme_service.dart';
import 'package:finance_trecker_alisa/session/app_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'I10n/app_localizations.dart';
import 'auth/enter_cubit/enter_auth_cubit.dart';
import 'go_router.dart';
import 'models/model_transaction.dart';

void main() async {
  // Инициализация системных служб:
  WidgetsFlutterBinding.ensureInitialized();

  bool darkTheme = await SettingsService.loadDarkTheme();
  bool screenshots = await PrivacyService.loadScreenshotProtection();
  ThemeService.setTheme(darkTheme);
  await PrivacyService.setScreenshotProtection(screenshots);

  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ModelTrancactionAdapter());
    await Hive.openBox<Model_Trancaction>('transactions');
    await Hive.openBox<Model_Trancaction>('history');
    //Создаем экземпляры Кубитов до runApp, чтобы передать их в роутер
    final appSessionCubit = AppSessionCubit();
    final enterAuthCubit = EnterAuthCubit();
    // Инициализируем роутер, передав ему кубит сессии
    final routerConfig = AppRouter(appSessionCubit).router;
    runApp(
      // Используем MultiBlocProvider как основной,
      // так как он расширяет MultiProvider
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: enterAuthCubit),
          BlocProvider.value(value: appSessionCubit),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => LocalSumProvider()),
            ChangeNotifierProvider(create: (_) => CurrencyProvider()),
          ],
          child: MyApp(router: routerConfig),
        ),
      ),
    );
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("Ошибка запуска: $e\nПопробуйте перезагрузить"),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeService.themeNotifier,
      builder: (context, ThemeMode mode, child) {
        return MaterialApp.router(
          themeMode: mode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          routerConfig: router,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('ru')],
        );
      },
    );
  }
}
