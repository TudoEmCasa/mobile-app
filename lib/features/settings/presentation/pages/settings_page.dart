import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/services/import/data_import_service.dart';
import 'package:tudo_em_casa/core/theme/theme_mode_provider.dart';
import 'package:tudo_em_casa/features/settings/presentation/viewmodels/settings_viewmodel.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Future<bool> _showImportConfirmationDialog(BuildContext context) async {
    final shouldImport = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Import Data'),
          content: const Text(
            'Importing a backup will replace current local data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );

    return shouldImport ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThemeMode = ref.watch(themeModeProvider);
    final isBusy = ref.watch(settingsViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.light,
                      label: Text('Light'),
                    ),
                    ButtonSegment<ThemeMode>(
                      value: ThemeMode.dark,
                      label: Text('Dark'),
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
            const SizedBox(height: 24),
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.file_upload_outlined),
                    title: const Text('Import Data'),
                    subtitle: const Text('Restore from a local JSON backup'),
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
                                  .pickImportData();

                              if (!context.mounted) {
                                return;
                              }

                              if (importPayload == null) {
                                AppSnackbar.info(context, 'Import canceled');
                                return;
                              }

                              final shouldImport =
                                  await _showImportConfirmationDialog(context);

                              if (!context.mounted) {
                                return;
                              }

                              if (!shouldImport) {
                                AppSnackbar.info(context, 'Import canceled');
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

                                AppSnackbar.error(context, error.message);
                                return;
                              }

                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.success(
                                context,
                                'Backup imported successfully',
                              );
                            } catch (_) {
                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.error(
                                context,
                                'Failed to restore local database',
                              );
                            }
                          },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined),
                    title: const Text('Export Data'),
                    subtitle: const Text('Create a local JSON backup'),
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
                                  .exportData();

                              if (!context.mounted) {
                                return;
                              }

                              if (exportedPath == null) {
                                AppSnackbar.info(context, 'Export canceled');
                                return;
                              }

                              AppSnackbar.success(
                                context,
                                'Backup exported successfully',
                              );
                            } catch (_) {
                              if (!context.mounted) {
                                return;
                              }

                              AppSnackbar.error(
                                context,
                                'Failed to export backup',
                              );
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('About', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Tudo em Casa'),
                    subtitle: Text('Version 1.0.0'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: const Text('Licenses'),
                    subtitle: const Text('View open source licenses'),
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: 'Tudo em Casa',
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
