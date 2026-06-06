import 'package:flutter/material.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class EmptyLotsWidget extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const EmptyLotsWidget({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.text('noLotsYet'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.text('createLotEmptyMessage'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreatePressed,
              child: Text(context.l10n.text('createLot')),
            ),
          ],
        ),
      ),
    );
  }
}
