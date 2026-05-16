import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeStorage {
  static const String _themeModeKey = 'app_theme_mode';

  Future<ThemeMode> loadThemeMode() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawThemeMode = sharedPreferences.getString(_themeModeKey);

    return switch (rawThemeMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      _themeModeKey,
      _toStorageValue(themeMode),
    );
  }

  String _toStorageValue(ThemeMode themeMode) {
    return switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
