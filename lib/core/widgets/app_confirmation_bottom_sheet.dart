import 'package:flutter/material.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

Future<bool> showAppConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  String? message,
  String? confirmLabel,
  String? cancelLabel,
  bool isDangerous = false,
}) async {
  final theme = Theme.of(context);
  final resolvedConfirmLabel = confirmLabel ?? context.l10n.text('confirm');
  final resolvedCancelLabel = cancelLabel ?? context.l10n.text('cancel');

  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (sheetContext) {
      final bottomInset = MediaQuery.viewInsetsOf(sheetContext).bottom;

      return Padding(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleLarge),
            if (message != null && message.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(message, style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(sheetContext).pop(true),
              style: isDangerous
                  ? FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    )
                  : FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
              child: Text(resolvedConfirmLabel),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(sheetContext).pop(false),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(resolvedCancelLabel),
            ),
          ],
        ),
      );
    },
  );

  return result ?? false;
}
