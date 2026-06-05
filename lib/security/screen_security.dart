import 'package:flutter/services.dart';

class ScreenSecurity {
  static void enable() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChannels.platform.invokeMethod(
      'SystemChrome.setApplicationSwitcherDescription',
    );
  }
}
