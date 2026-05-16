import 'package:flutter/material.dart';

class AppSnackbar {
  static const Duration _duration = Duration(seconds: 2);

  static void success(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      contentColor: Theme.of(context).colorScheme.onPrimaryContainer,
      icon: Icons.check_circle_outline,
    );
  }

  static void error(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      contentColor: Theme.of(context).colorScheme.onErrorContainer,
      icon: Icons.error_outline,
    );
  }

  static void info(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      contentColor: Theme.of(context).colorScheme.onSecondaryContainer,
      icon: Icons.info_outline,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color contentColor,
    required IconData icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: _duration,
          margin: const EdgeInsets.all(16),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              Icon(icon, size: 20, color: contentColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: TextStyle(color: contentColor)),
              ),
            ],
          ),
        ),
      );
  }
}
