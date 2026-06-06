import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_form_page.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/widgets/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class ProductTypeListPage extends ConsumerStatefulWidget {
  final bool selectionMode;
  final String? selectionTitle;
  final int? selectedProductTypeId;

  const ProductTypeListPage({
    super.key,
    this.selectionMode = false,
    this.selectionTitle,
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
          widget.selectionMode
              ? widget.selectionTitle ?? context.l10n.text('selectProductType')
              : context.l10n.text('productTypes'),
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
          showLoadErrorFeedback(context.l10n.text('failedToLoadProductTypes'));

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  context.l10n.text('failedToLoadProductTypes'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToProductTypeForm(context),
        tooltip: context.l10n.text('addProductType'),
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
        productType == null
            ? context.l10n.text('productTypeCreated')
            : context.l10n.text('productTypeUpdated'),
      );
    }
  }

  Future<void> _handleDeleteProductType(
    BuildContext context,
    WidgetRef ref,
    ProductTypeModel productType,
  ) async {
    final shouldDelete = await showAppConfirmationBottomSheet(
      context: context,
      title: context.l10n.text('deleteProductTypeTitle'),
      message: context.l10n.withName(
        'deleteNamedEntityMessage',
        productType.name,
      ),
      confirmLabel: context.l10n.text('delete'),
      cancelLabel: context.l10n.text('cancel'),
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(productTypeListViewModelProvider);
      await viewModel.deleteProductType(productType.id);
      if (context.mounted) {
        AppSnackbar.success(context, context.l10n.text('productTypeRemoved'));
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(
          context,
          context.l10n.text('failedToDeleteProductType'),
        );
      }
    }
  }
}
