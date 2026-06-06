import 'dart:convert';
import 'dart:io';

const portugueseLocalizationFiles = [
  'lib/l10n/app_pt.arb',
  'lib/l10n/app_pt_BR.arb',
];

const suspiciousPortugueseWords = <String, String>{
  'abreviacao': 'abreviação',
  'acao': 'ação',
  'aparencia': 'aparência',
  'codigo': 'código',
  'comecar': 'começar',
  'configuracoes': 'configurações',
  'disponivel': 'disponível',
  'disponiveis': 'disponíveis',
  'estao': 'estão',
  'exportacao': 'exportação',
  'historico': 'histórico',
  'importacao': 'importação',
  'invalido': 'inválido',
  'licencas': 'licenças',
  'nao': 'não',
  'obrigatoria': 'obrigatória',
  'obrigatorio': 'obrigatório',
  'organizacao': 'organização',
  'simbolo': 'símbolo',
  'valida': 'válida',
  'versao': 'versão',
};

List<String> findPortugueseLocalizationIssues({
  List<String> filePaths = portugueseLocalizationFiles,
}) {
  final failures = <String>[];

  for (final filePath in filePaths) {
    final file = File(filePath);
    final payload = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;

    for (final entry in payload.entries) {
      if (entry.key.startsWith('@') || entry.value is! String) {
        continue;
      }

      final value = entry.value! as String;
      final normalizedValue = value.toLowerCase();

      for (final suspiciousEntry in suspiciousPortugueseWords.entries) {
        final pattern = RegExp(
          r'(^|[^\p{L}])' + suspiciousEntry.key + r'($|[^\p{L}])',
          unicode: true,
        );

        if (pattern.hasMatch(normalizedValue)) {
          failures.add(
            '$filePath:${entry.key}: "$value" contains '
            '"${suspiciousEntry.key}". Consider "${suspiciousEntry.value}".',
          );
        }
      }
    }
  }

  return failures;
}
