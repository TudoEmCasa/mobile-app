import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tudo_em_casa/core/localization/language_preference.dart';

class LanguagePreferenceStorage {
  static const String _languagePreferenceKey = 'app_language_preference';

  Future<AppLanguagePreference?> loadLanguagePreference() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final rawLanguagePreference = sharedPreferences.getString(
      _languagePreferenceKey,
    );

    return switch (rawLanguagePreference) {
      'pt_BR' => AppLanguagePreference.portugueseBrazil,
      'en' => AppLanguagePreference.english,
      _ => null,
    };
  }

  Future<AppLanguagePreference> loadOrInitializeLanguagePreference(
    Locale deviceLocale,
  ) async {
    final persistedLanguagePreference = await loadLanguagePreference();

    if (persistedLanguagePreference != null) {
      return persistedLanguagePreference;
    }

    final initialLanguagePreference = AppLanguagePreference.fromDeviceLocale(
      deviceLocale,
    );
    await saveLanguagePreference(initialLanguagePreference);

    return initialLanguagePreference;
  }

  Future<void> saveLanguagePreference(
    AppLanguagePreference languagePreference,
  ) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      _languagePreferenceKey,
      _toStorageValue(languagePreference),
    );
  }

  String _toStorageValue(AppLanguagePreference languagePreference) {
    return switch (languagePreference) {
      AppLanguagePreference.portugueseBrazil => 'pt_BR',
      AppLanguagePreference.english => 'en',
    };
  }
}
