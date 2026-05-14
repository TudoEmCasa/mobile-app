import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;

  final VoidCallback? onTap;

  const CategoryItemWidget({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.name),
      subtitle: Text('ID: ${category.id}'),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
