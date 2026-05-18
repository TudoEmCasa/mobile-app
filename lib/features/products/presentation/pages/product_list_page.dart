import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_form_page.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_list_viewmodel.dart';
import 'package:tudo_em_casa/features/products/presentation/widgets/index.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();

  Future<void> _navigateToForm(
    BuildContext context, [
    ProductModel? product,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProductFormPage(product: product),
      ),
    );

    if (saved == true && context.mounted) {
      AppSnackbar.success(
        context,
        product == null ? 'Product created' : 'Product updated',
      );
    }
  }
}

class _ProductListPageState extends ConsumerState<ProductListPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(watchAllProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) {
          clearLoadErrorFeedback();

          if (products.isEmpty) {
            return EmptyProductsWidget(
              onCreatePressed: () => widget._navigateToForm(context),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductItemWidget(
                product: product,
                onEdit: () => widget._navigateToForm(context, product),
                onDelete: () => _handleDelete(context, ref, product),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          showLoadErrorFeedback('Failed to load products');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Failed to load products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget._navigateToForm(context),
        tooltip: 'Add Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _handleDelete(
    BuildContext context,
    WidgetRef ref,
    ProductModel product,
  ) async {
    final shouldDelete = await showAppConfirmationBottomSheet(
      context: context,
      title: 'Delete Product?',
      message: 'Delete "${product.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(productListViewModelProvider);
      await viewModel.deleteProduct(product.id);
      if (context.mounted) {
        AppSnackbar.success(context, 'Product removed');
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Failed to delete product');
      }
    }
  }
}
