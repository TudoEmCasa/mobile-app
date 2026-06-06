import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/localization/language_preference_provider.dart';
import 'package:tudo_em_casa/core/theme/app_theme.dart';
import 'package:tudo_em_casa/core/theme/theme_mode_provider.dart';
import 'package:tudo_em_casa/l10n/app_localizations.dart';
import 'package:tudo_em_casa/presentation/shell/app_shell_page.dart';

class TudoEmCasaApp extends ConsumerWidget {
  final Locale? locale;

  const TudoEmCasaApp({super.key, this.locale});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final languagePreference = ref.watch(languagePreferenceProvider);

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: locale ?? languagePreference.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppShellPage(),
    );
  }
}
