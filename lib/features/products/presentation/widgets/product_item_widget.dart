import 'package:flutter/material.dart';
import 'package:tudo_em_casa/core/utils/date_formatter.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onAdd;
  final VoidCallback? onUse;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.onAdd,
    this.onUse,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuantity = _totalQuantity;
    final unit = _firstUnit;
    final unitText = unit != null
        ? '${_formatQuantity(totalQuantity)} ${unit.symbol}'
        : _formatQuantity(totalQuantity);
    final productTypeName = product.productType?.name ?? '';
    final expirationText = _firstExpirationDate != null
        ? DateFormatter.formatDate(_firstExpirationDate!)
        : 'No expiration';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(product.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('$unitText • $productTypeName'),
            const SizedBox(height: 4),
            Text('Expires: $expirationText'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  onPressed: onAdd,
                  tooltip: 'Add quantity',
                  icon: const Icon(Icons.add_circle_outline),
                ),
                IconButton(
                  onPressed: onUse,
                  tooltip: 'Use product',
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit product',
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete product',
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double get _totalQuantity {
    return product.lots?.fold<double>(0, (sum, lot) => sum + lot.quantity) ?? 0;
  }

  UnitModel? get _firstUnit {
    final lots = product.lots;

    if (lots == null || lots.isEmpty) {
      return null;
    }

    return lots.first.unit;
  }

  DateTime? get _firstExpirationDate {
    final lots = product.lots;

    if (lots == null || lots.isEmpty) {
      return null;
    }

    return lots.first.expirationDate;
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }
}
