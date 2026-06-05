import 'dart:async';

import 'package:finance_trecker_alisa/session/app_session_cubit.dart';
import 'package:finance_trecker_alisa/ui/add_operation.dart';
import 'package:finance_trecker_alisa/ui/code_enter_page.dart';
import 'package:finance_trecker_alisa/ui/filters_page.dart';
import 'package:finance_trecker_alisa/ui/history_page.dart';
import 'package:finance_trecker_alisa/ui/registration_page.dart';
import 'package:finance_trecker_alisa/ui/settings_page.dart';
import 'package:finance_trecker_alisa/ui/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'components/main_navigation_container.dart';

class AppRouter {
  final AppSessionCubit appSessionCubit;
  AppRouter(this.appSessionCubit);
  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(appSessionCubit.stream),
    redirect: (context, state) {
      // Получаем состояние сессии
      final session = appSessionCubit.state;
      final isSplash = state.matchedLocation == '/splash';
      final isRegister = state.matchedLocation == '/register';
      final isAuth = state.matchedLocation == '/code_enter_page';
      // загрузка SplashPage
      if (isSplash) return null;
      // ЛОГИКА ПЕРВОГО ЗАПУСКА разрешаем ТОЛЬКО страницу регистрации
      if (session.isFirstRun) {
        return isRegister ? null : '/register';
      }
      //// Если не разблокировано — только ввод пин-кода:
      if (!session.isUnlocked) {
        return isAuth ? null : '/code_enter_page';
      }
      // ЕСЛИ РАЗБЛОКИРОВАНО
      // Если пользователь авторизован, но пытается зайти на страницы входа — отправляем в home
      if (session.isUnlocked && (isRegister || isAuth)) {
        return '/main_navigation_container';
      }
      return null;
    },
    // В остальных случаях идем куда хотели
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegistrationPage()),
      GoRoute(
        path: '/code_enter_page',
        builder: (_, __) => const CodEnterPage(),
      ),
      GoRoute(
        path: '/main_navigation_container',
        builder: (_, __) => const MainNavigationContainer(),
      ),
      GoRoute(path: '/add_operation', builder: (_, __) => const AddOperation()),
      GoRoute(path: '/filters_page', builder: (_, __) => const FiltersPage()),
      GoRoute(path: '/history_page', builder: (_, __) => const HistoryPage()),
      GoRoute(path: '/settings', builder: (_, __) => SettingsPage()),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
