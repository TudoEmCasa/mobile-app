import 'package:flutter/material.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class EmptyProductsWidget extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const EmptyProductsWidget({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              context.l10n.text('noProductsYet'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.text('createProductEmptyMessage'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreatePressed,
              child: Text(context.l10n.text('createProduct')),
            ),
          ],
        ),
      ),
    );
  }
}
