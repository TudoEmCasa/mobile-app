import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_form_page.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/widgets/index.dart';

class ProductTypeListPage extends ConsumerStatefulWidget {
  final bool selectionMode;
  final String selectionTitle;
  final int? selectedProductTypeId;

  const ProductTypeListPage({
    super.key,
    this.selectionMode = false,
    this.selectionTitle = 'Select Product Type',
    this.selectedProductTypeId,
  });

  @override
  ConsumerState<ProductTypeListPage> createState() =>
      _ProductTypeListPageState();
}

class _ProductTypeListPageState extends ConsumerState<ProductTypeListPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final productTypesAsync = ref.watch(productTypesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? widget.selectionTitle : 'Product Types',
        ),
      ),
      body: productTypesAsync.when(
        data: (productTypes) {
          clearLoadErrorFeedback();

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
                selectable: widget.selectionMode,
                selected: productType.id == widget.selectedProductTypeId,
                onSelected: widget.selectionMode
                    ? (selectedProductType) =>
                          Navigator.of(context).pop(selectedProductType)
                    : null,
                onEdit: () => _navigateToProductTypeForm(context, productType),
                onDelete: () =>
                    _handleDeleteProductType(context, ref, productType),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          showLoadErrorFeedback('Failed to load product types');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Failed to load product types',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProductTypeForm(context),
        tooltip: 'Add Product Type',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToProductTypeForm(
    BuildContext context, [
    ProductTypeModel? productType,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => ProductTypeFormPage(productType: productType),
      ),
    );

    if (saved == true && context.mounted) {
      AppSnackbar.success(
        context,
        productType == null ? 'Product type created' : 'Product type updated',
      );
    }
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
                  if (context.mounted) {
                    AppSnackbar.success(context, 'Product type removed');
                  }
                } catch (error) {
                  if (context.mounted) {
                    AppSnackbar.error(context, 'Failed to delete product type');
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
