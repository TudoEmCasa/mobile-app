import 'package:flutter/material.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class EmptyCategoriesWidget extends StatelessWidget {
  final VoidCallback onCreatePressed;

  const EmptyCategoriesWidget({super.key, required this.onCreatePressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            context.l10n.text('noCategoriesYet'),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.text('createCategoryEmptyMessage'),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreatePressed,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.text('createCategory')),
          ),
        ],
      ),
    );
  }
}
