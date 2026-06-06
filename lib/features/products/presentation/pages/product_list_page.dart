import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_details_page.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_form_page.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_list_viewmodel.dart';
import 'package:tudo_em_casa/features/products/presentation/widgets/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

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
        product == null
            ? context.l10n.text('productCreated')
            : context.l10n.text('productUpdated'),
      );
    }
  }

  Future<void> _navigateToDetails(
    BuildContext context,
    ProductModel product,
  ) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: product.id),
      ),
    );
  }
}

class _ProductListPageState extends ConsumerState<ProductListPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(watchAllProductsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.text('products'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: productsAsync.when(
                  data: (products) {
                    clearLoadErrorFeedback();

                    if (products.isEmpty) {
                      return EmptyProductsWidget(
                        onCreatePressed: () => widget._navigateToForm(context),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItemWidget(
                          product: product,
                          onTap: () =>
                              widget._navigateToDetails(context, product),
                          onEdit: () =>
                              widget._navigateToForm(context, product),
                          onDelete: () => _handleDelete(context, ref, product),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) {
                    showLoadErrorFeedback(
                      context.l10n.text('failedToLoadProducts'),
                    );

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.text('failedToLoadProducts'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => widget._navigateToForm(context),
        tooltip: context.l10n.text('addProduct'),
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
      title: context.l10n.text('deleteProductTitle'),
      message: context.l10n.withName('deleteNamedEntityMessage', product.name),
      confirmLabel: context.l10n.text('delete'),
      cancelLabel: context.l10n.text('cancel'),
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(productListViewModelProvider);
      await viewModel.deleteProduct(product.id);
      if (context.mounted) {
        AppSnackbar.success(context, context.l10n.text('productRemoved'));
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToDeleteProduct'));
      }
    }
  }
}
