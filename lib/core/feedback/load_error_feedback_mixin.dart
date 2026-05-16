import 'package:flutter/material.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';

mixin LoadErrorFeedbackMixin<T extends StatefulWidget> on State<T> {
  String? _lastLoadErrorMessage;

  void showLoadErrorFeedback(String message) {
    if (_lastLoadErrorMessage == message) {
      return;
    }

    _lastLoadErrorMessage = message;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AppSnackbar.error(context, message);
      }
    });
  }

  void clearLoadErrorFeedback() {
    _lastLoadErrorMessage = null;
  }
}
