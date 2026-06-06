import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/lots/presentation/pages/index.dart';
import 'package:tudo_em_casa/features/lots/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/lots/presentation/widgets/index.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_details_viewmodel.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productStreamProvider(widget.productId));
    final lotsAsync = ref.watch(
      lotsByProductIdStreamProvider(widget.productId),
    );
    final productTitle =
        productAsync.maybeWhen(
          data: (product) => product?.name,
          orElse: () => null,
        ) ??
        context.l10n.text('productDetails');

    return Scaffold(
      appBar: AppBar(title: Text(productTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: productAsync.maybeWhen(
          data: (product) => product != null
              ? () => _navigateToLotForm(context, product)
              : null,
          orElse: () => null,
        ),
        tooltip: context.l10n.text('addLot'),
        child: const Icon(Icons.add),
      ),
      body: productAsync.when(
        data: (product) {
          clearLoadErrorFeedback();

          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.text('productNotFound'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return lotsAsync.when(
            data: (lots) {
              final productTypeName =
                  product.productType?.name ?? context.l10n.text('unknown');
              final categoryName =
                  product.productType?.category?.name ??
                  context.l10n.text('unknown');

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.withName(
                              'productTypeWithName',
                              productTypeName,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.l10n.withName(
                              'categoryWithName',
                              categoryName,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            context.l10n.withCount('lotsCount', lots.length),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(context.l10n.text('inventoryTrackedPerLot')),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.text('lots'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextButton.icon(
                        onPressed: () => _navigateToLotForm(context, product),
                        icon: const Icon(Icons.add),
                        label: Text(context.l10n.text('addLotLower')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (lots.isEmpty)
                    EmptyLotsWidget(
                      onCreatePressed: () =>
                          _navigateToLotForm(context, product),
                    )
                  else
                    ...lots.map(
                      (lot) => LotItemWidget(
                        lot: lot,
                        onTap: () => _navigateToLotForm(context, product, lot),
                        onAddQuantity: () =>
                            _handleAddQuantity(context, ref, lot),
                        onUseQuantity: () =>
                            _handleUseQuantity(context, ref, lot),
                        onEdit: () => _navigateToLotForm(context, product, lot),
                        onDelete: () => _handleDeleteLot(context, ref, lot),
                      ),
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) {
              showLoadErrorFeedback(context.l10n.text('failedToLoadLots'));
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
                      context.l10n.text('failedToLoadLots'),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          showLoadErrorFeedback(context.l10n.text('failedToLoadProduct'));
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  context.l10n.text('failedToLoadProduct'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _navigateToLotForm(
    BuildContext context,
    ProductModel product, [
    LotModel? lot,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => LotFormPage(product: product, lot: lot),
      ),
    );

    if (saved == true && context.mounted) {
      AppSnackbar.success(
        context,
        lot == null
            ? context.l10n.text('lotCreated')
            : context.l10n.text('lotUpdated'),
      );
    }
  }

  Future<void> _handleDeleteLot(
    BuildContext context,
    WidgetRef ref,
    LotModel lot,
  ) async {
    final shouldDelete = await showAppConfirmationBottomSheet(
      context: context,
      title: context.l10n.text('deleteLotTitle'),
      message: context.l10n.text('deleteLotMessage'),
      confirmLabel: context.l10n.text('delete'),
      cancelLabel: context.l10n.text('cancel'),
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(lotListViewModelProvider);
      await viewModel.deleteLot(lot.id);
      if (context.mounted) {
        AppSnackbar.success(context, context.l10n.text('lotRemoved'));
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToDeleteLot'));
      }
    }
  }

  Future<void> _handleUseQuantity(
    BuildContext context,
    WidgetRef ref,
    LotModel lot,
  ) async {
    final quantity = await showLotQuantityAdjustmentBottomSheet(
      context: context,
      lot: lot,
      mode: LotQuantityAdjustmentMode.consume,
    );

    if (quantity == null || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(lotListViewModelProvider);
      await viewModel.consumeLotQuantity(lotId: lot.id, quantity: quantity);

      if (context.mounted) {
        AppSnackbar.success(
          context,
          context.l10n.withQuantity('quantityUsed', _formatQuantity(quantity)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, _quantityErrorMessage(context, error));
      }
    }
  }

  Future<void> _handleAddQuantity(
    BuildContext context,
    WidgetRef ref,
    LotModel lot,
  ) async {
    final quantity = await showLotQuantityAdjustmentBottomSheet(
      context: context,
      lot: lot,
      mode: LotQuantityAdjustmentMode.add,
    );

    if (quantity == null || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(lotListViewModelProvider);
      await viewModel.addLotQuantity(lotId: lot.id, quantity: quantity);

      if (context.mounted) {
        AppSnackbar.success(
          context,
          context.l10n.withQuantity('quantityAdded', _formatQuantity(quantity)),
        );
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, _quantityErrorMessage(context, error));
      }
    }
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }

  String _quantityErrorMessage(BuildContext context, Object error) {
    final message = error.toString();

    if (message.contains('Quantity must be greater than zero')) {
      return context.l10n.text('quantityMustBeGreaterThanZero');
    }

    if (message.contains('Insufficient quantity')) {
      return context.l10n.text('insufficientQuantity');
    }

    if (message.contains('Lot not found')) {
      return context.l10n.text('failedToLoadLots');
    }

    if (message.contains('Product not found')) {
      return context.l10n.text('productNotFound');
    }

    return message;
  }
}
