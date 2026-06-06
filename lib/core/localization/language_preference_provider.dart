import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/localization/language_preference.dart';
import 'package:tudo_em_casa/core/localization/language_preference_storage.dart';

final languagePreferenceStorageProvider = Provider<LanguagePreferenceStorage>((
  ref,
) {
  return LanguagePreferenceStorage();
});

final initialLanguagePreferenceProvider = Provider<AppLanguagePreference>((
  ref,
) {
  return AppLanguagePreference.english;
});

final languagePreferenceProvider =
    NotifierProvider<LanguagePreferenceNotifier, AppLanguagePreference>(
      LanguagePreferenceNotifier.new,
    );

class LanguagePreferenceNotifier extends Notifier<AppLanguagePreference> {
  @override
  AppLanguagePreference build() {
    return ref.watch(initialLanguagePreferenceProvider);
  }

  Future<void> setLanguagePreference(
    AppLanguagePreference languagePreference,
  ) async {
    if (state == languagePreference) {
      return;
    }

    state = languagePreference;
    await ref
        .read(languagePreferenceStorageProvider)
        .saveLanguagePreference(languagePreference);
  }
}
