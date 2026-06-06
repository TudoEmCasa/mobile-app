import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/app.dart';
import 'package:tudo_em_casa/l10n/app_localizations.dart';

void main() {
  test('TudoEmCasaApp can be instantiated', () {
    expect(const TudoEmCasaApp(), isNotNull);
  });

  test('loads Portuguese labels when locale is pt_BR', () async {
    final localizations = await AppLocalizations.delegate.load(
      const Locale('pt', 'BR'),
    );

    expect(localizations.products, 'Produtos');
    expect(localizations.management, 'Gerenciar');
    expect(localizations.settings, 'Ajustes');
  });
}
