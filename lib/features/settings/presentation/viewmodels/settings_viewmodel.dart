import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/services/export/data_export_service_provider.dart';

final settingsViewModelProvider = NotifierProvider<SettingsViewModel, bool>(
  SettingsViewModel.new,
);

class SettingsViewModel extends Notifier<bool> {
  @override
  bool build() => false;

  Future<String?> exportData() async {
    if (state) {
      throw StateError('Export already in progress');
    }

    state = true;

    try {
      return ref.read(dataExportServiceProvider).exportData();
    } finally {
      state = false;
    }
  }
}
