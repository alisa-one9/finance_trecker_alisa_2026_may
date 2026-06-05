import 'package:finance_trecker_alisa/services/privacy_service.dart';
import 'package:flutter/material.dart';

import '../services/settings_service.dart';
import '../services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool dark_current_theme = false;
  bool statusScreenshots = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    dark_current_theme = await SettingsService.loadDarkTheme();
    statusScreenshots = await PrivacyService.loadScreenshotProtection();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),

      body: Column(
        children: [
          const SizedBox(height: 40),
          // THEME
          SwitchListTile(
            title: const Text(
              "Светлая тема/Темная тема",
              style: TextStyle(color: Colors.deepPurple),
            ),
            value: dark_current_theme,
            onChanged: (value) async {
              setState(() {
                dark_current_theme = value;
              });
              await SettingsService.saveDarkTheme(value);

              ThemeService.setTheme(value);
            },
          ),

          const SizedBox(height: 40),

          // SCREENSHOTS
          SwitchListTile(
            title: const Text(
              "Запретить фото-, видео-запись экрана",
              style: TextStyle(color: Colors.deepPurple),
            ),

            value: statusScreenshots,

            onChanged: (value) async {
              setState(() {
                statusScreenshots = value;
              });

              await PrivacyService.setScreenshotProtection(value);

              await PrivacyService.saveScreenshotProtection(value);
            },
          ),
        ],
      ),
    );
  }
}
