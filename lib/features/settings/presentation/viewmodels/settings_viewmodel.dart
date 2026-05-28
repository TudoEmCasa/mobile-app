import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/services/export/data_export_service_provider.dart';
import 'package:tudo_em_casa/core/services/import/data_import_service.dart';
import 'package:tudo_em_casa/core/services/import/data_import_service_provider.dart';

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

  Future<BackupImportPayload?> pickImportData() async {
    if (state) {
      throw StateError('Import already in progress');
    }

    state = true;

    try {
      return ref.read(dataImportServiceProvider).pickBackupFile();
    } finally {
      state = false;
    }
  }

  Future<void> importData(BackupImportPayload payload) async {
    if (state) {
      throw StateError('Import already in progress');
    }

    state = true;

    try {
      await ref.read(dataImportServiceProvider).importBackup(payload);
    } finally {
      state = false;
    }
  }
}
