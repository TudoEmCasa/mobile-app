import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/theme/app_theme.dart';
import 'package:tudo_em_casa/core/theme/theme_mode_provider.dart';
import 'package:tudo_em_casa/presentation/shell/app_shell_page.dart';

class TudoEmCasaApp extends ConsumerWidget {
  const TudoEmCasaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Tudo em Casa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const AppShellPage(),
    );
  }
}
