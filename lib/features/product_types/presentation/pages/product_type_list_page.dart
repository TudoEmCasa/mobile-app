import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_form_page.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/widgets/index.dart';

class ProductTypeListPage extends ConsumerWidget {
  const ProductTypeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productTypesAsync = ref.watch(productTypesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Types')),
      body: productTypesAsync.when(
        data: (productTypes) {
          if (productTypes.isEmpty) {
            return EmptyProductTypesWidget(
              onCreatePressed: () => _navigateToProductTypeForm(context),
            );
          }

          return ListView.builder(
            itemCount: productTypes.length,
            itemBuilder: (context, index) {
              final productType = productTypes[index];
              return ProductTypeItemWidget(
                productType: productType,
                onEdit: () => _navigateToProductTypeForm(context, productType),
                onDelete: () =>
                    _handleDeleteProductType(context, ref, productType),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Error loading product types',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProductTypeForm(context),
        tooltip: 'Add Product Type',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToProductTypeForm(
    BuildContext context, [
    ProductTypeModel? productType,
  ]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductTypeFormPage(productType: productType),
      ),
    );
  }

  void _handleDeleteProductType(
    BuildContext context,
    WidgetRef ref,
    ProductTypeModel productType,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product Type?'),
          content: Text(
            'Delete "${productType.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final viewModel = ref.read(productTypeListViewModelProvider);
                  await viewModel.deleteProductType(productType.id);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting product type: $error'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
