import 'package:flutter/material.dart';
import 'package:tudo_em_casa/core/utils/date_formatter.dart';
import 'package:tudo_em_casa/features/lots/data/models/lot_model.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';

class ProductItemWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductItemWidget({
    super.key,
    required this.product,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final lotSummary = _buildLotSummary();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: onTap,
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(product.name),
              subtitle: Text(lotSummary),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
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

  String _buildLotSummary() {
    final lots = product.lots;

    if (lots == null || lots.isEmpty) {
      return 'No lots registered';
    }

    final lot = _selectNearestExpiringLot(lots);
    final quantityText = _formatQuantity(lot.quantity);
    final unitText = lot.unit?.symbol ?? lot.unit?.name ?? 'units';
    final expirationText = lot.expirationDate != null
        ? DateFormatter.formatDate(lot.expirationDate!)
        : 'No expiration date';

    return '$quantityText $unitText • $expirationText';
  }

  LotModel _selectNearestExpiringLot(List<LotModel> lots) {
    final lotsWithExpiration =
        lots.where((lot) => lot.expirationDate != null).toList()
          ..sort((left, right) {
            final leftExpiration = left.expirationDate;
            final rightExpiration = right.expirationDate;
            return leftExpiration!.compareTo(rightExpiration!);
          });

    if (lotsWithExpiration.isNotEmpty) {
      return lotsWithExpiration.first;
    }

    return lots.first;
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }
}
