import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/theme/theme_mode_storage.dart';

final themeModeStorageProvider = Provider<ThemeModeStorage>((ref) {
  return ThemeModeStorage();
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    if (state == themeMode) {
      return;
    }

    state = themeMode;
    await ref.read(themeModeStorageProvider).saveThemeMode(themeMode);
  }

  Future<void> _loadThemeMode() async {
    final persistedThemeMode = await ref
        .read(themeModeStorageProvider)
        .loadThemeMode();

    if (state != persistedThemeMode) {
      state = persistedThemeMode;
    }
  }
}
