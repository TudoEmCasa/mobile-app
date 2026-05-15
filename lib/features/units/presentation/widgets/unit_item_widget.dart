import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';

class UnitItemWidget extends StatelessWidget {
  final UnitModel unit;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UnitItemWidget({
    super.key,
    required this.unit,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
