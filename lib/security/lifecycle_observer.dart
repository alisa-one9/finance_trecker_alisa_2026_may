import 'package:flutter/cupertino.dart';

import '../session/app_session_cubit.dart';

class LifecycleService with WidgetsBindingObserver {
  final AppSessionCubit session;
  LifecycleService(this.session);
  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      session.lock();
    }
    if (state == AppLifecycleState.resumed) {
      session.lock();
    }
  }
}
