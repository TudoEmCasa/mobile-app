import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final bool selectable;
  final bool selected;
  final ValueChanged<CategoryModel>? onSelected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryItemWidget({
    super.key,
    required this.category,
    this.selectable = false,
    this.selected = false,
    this.onSelected,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: selectable ? () => onSelected?.call(category) : onEdit,
      leading: selectable
          ? Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? colorScheme.primary : colorScheme.outline,
            )
          : null,
      title: Text(category.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}
