import 'package:flutter/material.dart';
import 'package:tudo_em_casa/core/utils/date_formatter.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';

class LotItemWidget extends StatelessWidget {
  final LotModel lot;
  final VoidCallback? onTap;
  final VoidCallback? onAddQuantity;
  final VoidCallback? onUseQuantity;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LotItemWidget({
    super.key,
    required this.lot,
    this.onTap,
    this.onAddQuantity,
    this.onUseQuantity,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final quantityText = _formatQuantity(lot.quantity);
    final unitText = lot.unit?.symbol ?? lot.unit?.name ?? 'units';
    final expirationText = lot.expirationDate != null
        ? DateFormatter.formatDate(lot.expirationDate!)
        : 'No expiration';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.sell_outlined),
        title: Text('$quantityText $unitText'),
        subtitle: Text('Expires: $expirationText'),
        trailing: Wrap(
          spacing: 2,
          children: [
            IconButton(
              onPressed: onAddQuantity,
              tooltip: 'Add quantity',
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              onPressed: onUseQuantity,
              tooltip: 'Use quantity',
              icon: const Icon(Icons.remove_circle_outline),
            ),
            IconButton(
              onPressed: onEdit,
              tooltip: 'Edit lot',
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onDelete,
              tooltip: 'Delete lot',
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }
}
