import 'package:flutter/material.dart';

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
              'No products yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your first product catalog entry to get started.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCreatePressed,
              child: const Text('Create Product'),
            ),
          ],
        ),
      ),
    );
  }
}
