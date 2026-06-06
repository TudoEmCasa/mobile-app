import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/localization/language_preference.dart';
import 'package:tudo_em_casa/core/localization/language_preference_provider.dart';
import 'package:tudo_em_casa/core/services/import/data_import_service.dart';
import 'package:tudo_em_casa/core/theme/theme_mode_provider.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/settings/presentation/viewmodels/settings_viewmodel.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemeMode = ref.watch(themeModeProvider);
    final selectedLanguagePreference = ref.watch(languagePreferenceProvider);
    final isBusy = ref.watch(settingsViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              context.l10n.text('settings'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.text('appearance'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text(context.l10n.text('systemTheme')),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text(context.l10n.text('lightTheme')),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text(context.l10n.text('darkTheme')),
                    ),
                  ],
                  selected: {selectedThemeMode},
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) {
                      return;
                    }

                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(selection.first);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.text('language'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<AppLanguagePreference>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment<AppLanguagePreference>(
                      value: AppLanguagePreference.portugueseBrazil,
                      label: Text(context.l10n.text('portugueseLanguage')),
                    ),
                    ButtonSegment<AppLanguagePreference>(
                      value: AppLanguagePreference.english,
                      label: Text(context.l10n.text('englishLanguage')),
                    ),
                  ],
                  selected: {selectedLanguagePreference},
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) {
                      return;
                    }

                    ref
                        .read(languagePreferenceProvider.notifier)
                        .setLanguagePreference(selection.first);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.text('dataManagement'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: Text(context.l10n.text('importData')),
                    subtitle: Text(context.l10n.text('importDataSubtitle')),
                    enabled: !isBusy,
                    trailing: isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: isBusy
                        ? null
                        : () async {
                            try {
                              final importPayload = await ref
                                  .read(settingsViewModelProvider.notifier)
                                  .pickImportData(
                                    dialogTitle: context.l10n.text(
                                      'importDataBackupDialogTitle',
                                    ),
                                  );

                              if (!context.mounted) {
                                return;
                              }

                              if (importPayload == null) {
                                AppSnackbar.info(
                                  context,
                                  context.l10n.text('importCanceled'),
                                );
                                return;
                              }

                              final shouldImport =
                                  await showAppConfirmationBottomSheet(
                                    context: context,
                                    title: context.l10n.text('importData'),
                                    message: context.l10n.text(
                                      'importConfirmationMessage',
                                    ),
                                    confirmLabel: context.l10n.text(
                                      'importData',
                                    ),
                                    cancelLabel: context.l10n.text('cancel'),
                                    isDangerous: true,
                                  );

                              if (!context.mounted) {
                                return;
                              }

                              if (!shouldImport) {
                                AppSnackbar.info(
                                  context,
                                  context.l10n.text('importCanceled'),
                                );
                                return;
                              }

                              try {
                                await ref
                                    .read(settingsViewModelProvider.notifier)
                                    .importData(importPayload);
                              } on DataImportException catch (error) {
                                if (!context.mounted) {
                                  return;
                                }

                                AppSnackbar.error(
                                  context,
                                  _importErrorMessage(context, error),
                                );
                                return;
                              }

                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.success(
                                context,
                                context.l10n.text('backupImportedSuccessfully'),
                              );
                            } catch (_) {
                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.error(
                                context,
                                context.l10n.text(
                                  'failedToRestoreLocalDatabase',
                                ),
                              );
                            }
                          },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: Text(context.l10n.text('exportData')),
                    subtitle: Text(context.l10n.text('exportDataSubtitle')),
                    enabled: !isBusy,
                    trailing: isBusy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: isBusy
                        ? null
                        : () async {
                            try {
                              final exportedPath = await ref
                                  .read(settingsViewModelProvider.notifier)
                                  .exportData(
                                    dialogTitle: context.l10n.text(
                                      'exportDataBackupDialogTitle',
                                    ),
                                  );

                              if (!context.mounted) {
                                return;
                              }

                              if (exportedPath == null) {
                                AppSnackbar.info(
                                  context,
                                  context.l10n.text('exportCanceled'),
                                );
                                return;
                              }

                              AppSnackbar.success(
                                context,
                                context.l10n.text('backupExportedSuccessfully'),
                              );
                            } catch (_) {
                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.error(
                                context,
                                context.l10n.text('failedToExportBackup'),
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.text('about'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(context.l10n.text('appTitle')),
                    subtitle: Text(context.l10n.text('versionLabel')),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(context.l10n.text('licenses')),
                    subtitle: Text(context.l10n.text('licensesSubtitle')),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: context.l10n.text('appTitle'),
                        applicationVersion: '1.0.0',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _importErrorMessage(BuildContext context, DataImportException error) {
  return switch (error.message) {
    'Backup data is corrupted.' => context.l10n.text('backupDataCorrupted'),
    'Unsupported backup version.' => context.l10n.text(
      'unsupportedBackupVersion',
    ),
    'Failed to restore local database.' => context.l10n.text(
      'failedToRestoreLocalDatabase',
    ),
    'Invalid backup file.' => context.l10n.text('invalidBackupFile'),
    _ => context.l10n.text('invalidBackupFile'),
  };
}
