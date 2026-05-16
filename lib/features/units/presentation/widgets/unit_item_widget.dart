import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';

class UnitItemWidget extends StatelessWidget {
  final UnitModel unit;
  final bool selectable;
  final bool selected;
  final ValueChanged<UnitModel>? onSelected;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UnitItemWidget({
    super.key,
    required this.unit,
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
      onTap: selectable ? () => onSelected?.call(unit) : onEdit,
      leading: selectable
          ? Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? colorScheme.primary : colorScheme.outline,
            )
          : null,
      title: Text(unit.name),
      subtitle: Text(unit.symbol),
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
