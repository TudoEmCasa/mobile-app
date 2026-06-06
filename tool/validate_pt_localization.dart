import 'dart:io';

import 'pt_localization_validator.dart';

void main() {
  final failures = findPortugueseLocalizationIssues();

  if (failures.isEmpty) {
    return;
  }

  stderr.writeln('Suspicious Portuguese localization terms found:');
  for (final failure in failures) {
    stderr.writeln('- $failure');
  }
  exitCode = 1;
}
