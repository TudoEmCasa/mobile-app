import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tudo_em_casa/app.dart';
import 'package:tudo_em_casa/core/localization/language_preference_provider.dart';
import 'package:tudo_em_casa/core/localization/language_preference_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final languagePreferenceStorage = LanguagePreferenceStorage();
  final initialLanguagePreference = await languagePreferenceStorage
      .loadOrInitializeLanguagePreference(PlatformDispatcher.instance.locale);
  Intl.defaultLocale = initialLanguagePreference.locale.toString();

  runApp(
    ProviderScope(
      overrides: [
        languagePreferenceStorageProvider.overrideWithValue(
          languagePreferenceStorage,
        ),
        initialLanguagePreferenceProvider.overrideWithValue(
          initialLanguagePreference,
        ),
      ],
      child: const TudoEmCasaApp(),
    ),
  );
}
