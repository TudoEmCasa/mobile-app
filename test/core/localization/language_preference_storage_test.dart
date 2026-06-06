import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tudo_em_casa/core/localization/language_preference.dart';
import 'package:tudo_em_casa/core/localization/language_preference_storage.dart';

void main() {
  late LanguagePreferenceStorage storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = LanguagePreferenceStorage();
  });

  test(
    'initializes Portuguese preference for Portuguese device locale',
    () async {
      final preference = await storage.loadOrInitializeLanguagePreference(
        const Locale('pt', 'BR'),
      );

      expect(preference, AppLanguagePreference.portugueseBrazil);
      expect(preference.locale, const Locale('pt', 'BR'));
      expect(await storage.loadLanguagePreference(), preference);
    },
  );

  test(
    'initializes English preference for non-Portuguese device locale',
    () async {
      final preference = await storage.loadOrInitializeLanguagePreference(
        const Locale('es'),
      );

      expect(preference, AppLanguagePreference.english);
      expect(preference.locale, const Locale('en'));
      expect(await storage.loadLanguagePreference(), preference);
    },
  );

  test('keeps persisted preference over Portuguese device locale', () async {
    await storage.saveLanguagePreference(AppLanguagePreference.english);

    final preference = await storage.loadOrInitializeLanguagePreference(
      const Locale('pt', 'BR'),
    );

    expect(preference, AppLanguagePreference.english);
    expect(preference.locale, const Locale('en'));
  });

  test('persists Portuguese preference as pt_BR locale', () async {
    await storage.saveLanguagePreference(
      AppLanguagePreference.portugueseBrazil,
    );

    final preference = await storage.loadLanguagePreference();

    expect(preference, AppLanguagePreference.portugueseBrazil);
    expect(preference?.locale, const Locale('pt', 'BR'));
  });

  test('persists English preference as en locale', () async {
    await storage.saveLanguagePreference(AppLanguagePreference.english);

    final preference = await storage.loadLanguagePreference();

    expect(preference, AppLanguagePreference.english);
    expect(preference?.locale, const Locale('en'));
  });
}
