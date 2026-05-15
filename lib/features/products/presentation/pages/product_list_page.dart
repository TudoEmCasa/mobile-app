import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_form_page.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_list_viewmodel.dart';
import 'package:tudo_em_casa/features/products/presentation/widgets/index.dart';

class ProductListPage extends ConsumerWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(watchAllProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return EmptyProductsWidget(
              onCreatePressed: () => _navigateToForm(context),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemWidget(
                product: product,
                onEdit: () => _navigateToForm(context, product),
                onDelete: () => _handleDelete(context, ref, product),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Error loading products: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(context),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToForm(BuildContext context, [ProductModel? product]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product),
      ),
    );
  }

  void _handleDelete(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Product?'),
          content: Text(
            'Delete "${product.name}"? This action cannot be undone.',
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
                  final viewModel = ref.read(productListViewModelProvider);
                  await viewModel.deleteProduct(product.id);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting product: $error')),
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
