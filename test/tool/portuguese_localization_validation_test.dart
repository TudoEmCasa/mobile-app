import 'package:flutter_test/flutter_test.dart';

import '../../tool/pt_localization_validator.dart';

void main() {
  test(
    'Portuguese localization files do not contain common unaccented words',
    () {
      final issues = findPortugueseLocalizationIssues();

      expect(issues, isEmpty);
    },
  );
}
