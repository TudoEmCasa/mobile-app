import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';

class ProductTypeItemWidget extends StatelessWidget {
  final ProductTypeWithCategoryModel productType;

  final VoidCallback? onTap;

  const ProductTypeItemWidget({
    super.key,
    required this.productType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productType.name),
      subtitle: Text('Category: ${productType.categoryName}'),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
