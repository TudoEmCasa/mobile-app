import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class ProductTypeItemWidget extends StatelessWidget {
  final ProductTypeModel productType;
  final bool selectable;
  final bool selected;
  final ValueChanged<ProductTypeModel>? onSelected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductTypeItemWidget({
    super.key,
    required this.productType,
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
      onTap: selectable ? () => onSelected?.call(productType) : onEdit,
      leading: selectable
          ? Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? colorScheme.primary : colorScheme.outline,
            )
          : null,
      title: Text(productType.name),
      subtitle: Text(
        context.l10n.withName(
          'categoryWithName',
          productType.category?.name ?? context.l10n.text('unknown'),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
            tooltip: context.l10n.text('edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
            tooltip: context.l10n.text('delete'),
          ),
        ],
      ),
    );
  }
}
