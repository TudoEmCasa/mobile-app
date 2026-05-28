import 'package:flutter/material.dart';
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
    final productTypeName = product.productType?.name ?? '';
    final categoryName = product.productType?.category?.name;

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
              subtitle: Text(
                categoryName == null || categoryName.isEmpty
                    ? productTypeName
                    : '$productTypeName • $categoryName',
              ),
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
}
