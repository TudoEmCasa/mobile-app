import 'package:flutter/material.dart';
import 'package:tudo_em_casa/presentation/shell/app_shell_page.dart';

class TudoEmCasaApp extends StatelessWidget {
  const TudoEmCasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tudo em Casa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AppShellPage(),
    );
  }
}
