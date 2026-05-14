import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';

class ProductTypeItemWidget extends StatelessWidget {
  final ProductTypeModel productType;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductTypeItemWidget({
    super.key,
    required this.productType,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productType.name),
      subtitle: Text('Category: ${productType.category?.name ?? 'Unknown'}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
    );
  }
}
