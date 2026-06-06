import 'package:flutter/widgets.dart';

enum AppLanguagePreference {
  portugueseBrazil,
  english;

  Locale get locale {
    return switch (this) {
      AppLanguagePreference.portugueseBrazil => const Locale('pt', 'BR'),
      AppLanguagePreference.english => const Locale('en'),
    };
  }

  static AppLanguagePreference fromDeviceLocale(Locale locale) {
    if (locale.languageCode.toLowerCase().startsWith('pt')) {
      return AppLanguagePreference.portugueseBrazil;
    }

    return AppLanguagePreference.english;
  }
}
