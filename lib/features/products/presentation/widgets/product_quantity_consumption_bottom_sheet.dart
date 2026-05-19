import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';

enum ProductQuantityAdjustmentMode { add, consume }

Future<double?> showProductQuantityAdjustmentBottomSheet({
  required BuildContext context,
  required ProductModel product,
  required ProductQuantityAdjustmentMode mode,
}) async {
  return showModalBottomSheet<double>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: true,
    enableDrag: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return _ProductQuantityAdjustmentSheet(product: product, mode: mode);
    },
  );
}

Future<double?> showProductQuantityConsumptionBottomSheet({
  required BuildContext context,
  required ProductModel product,
}) {
  return showProductQuantityAdjustmentBottomSheet(
    context: context,
    product: product,
    mode: ProductQuantityAdjustmentMode.consume,
  );
}

class _ProductQuantityAdjustmentSheet extends StatefulWidget {
  final ProductModel product;
  final ProductQuantityAdjustmentMode mode;

  const _ProductQuantityAdjustmentSheet({
    required this.product,
    required this.mode,
  });

  @override
  State<_ProductQuantityAdjustmentSheet> createState() =>
      _ProductQuantityAdjustmentSheetState();
}

class _ProductQuantityAdjustmentSheetState
    extends State<_ProductQuantityAdjustmentSheet> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _quantityController.addListener(_handleQuantityChanged);
  }

  @override
  void dispose() {
    _quantityController.removeListener(_handleQuantityChanged);
    _quantityController.dispose();
    super.dispose();
  }

  void _handleQuantityChanged() {
    setState(() {});
  }

  double? get _enteredQuantity {
    final text = _quantityController.text.trim();

    if (text.isEmpty) {
      return null;
    }

    final quantity = double.tryParse(text);

    if (quantity == null || !quantity.isFinite) {
      return null;
    }

    return quantity;
  }

  String? get _quantityErrorText {
    final text = _quantityController.text.trim();

    if (text.isEmpty) {
      return 'Enter a quantity';
    }

    final quantity = double.tryParse(text);

    if (quantity == null || !quantity.isFinite) {
      return 'Enter a valid quantity';
    }

    if (quantity <= 0) {
      return 'Quantity must be greater than zero';
    }

    if (widget.mode == ProductQuantityAdjustmentMode.consume &&
        quantity > widget.product.quantity) {
      return 'Insufficient quantity';
    }

    return null;
  }

  double? get _previewQuantity {
    final enteredQuantity = _enteredQuantity;

    if (enteredQuantity == null) {
      return null;
    }

    return widget.mode == ProductQuantityAdjustmentMode.consume
        ? widget.product.quantity - enteredQuantity
        : widget.product.quantity + enteredQuantity;
  }

  bool get _canConfirm => _quantityErrorText == null;

  String get _title {
    return widget.mode == ProductQuantityAdjustmentMode.consume
        ? 'Consume quantity'
        : 'Add quantity';
  }

  String get _quantityLabel {
    return widget.mode == ProductQuantityAdjustmentMode.consume
        ? 'Quantity to use'
        : 'Quantity to add';
  }

  String get _previewLabel {
    return widget.mode == ProductQuantityAdjustmentMode.consume
        ? 'Remaining'
        : 'New total';
  }

  void _useAllQuantity() {
    if (widget.mode != ProductQuantityAdjustmentMode.consume) {
      return;
    }

    final quantityText = _formatQuantity(widget.product.quantity);

    _quantityController.value = TextEditingValue(
      text: quantityText,
      selection: TextSelection.collapsed(offset: quantityText.length),
    );
  }

  void _confirm() {
    final quantity = _enteredQuantity;

    if (quantity == null || !_canConfirm) {
      return;
    }

    Navigator.of(context).pop(quantity);
  }

  String _formatQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    return quantity.toString();
  }

  String _unitLabel(double quantity) {
    final unitName = widget.product.unit?.name.trim();

    if (unitName == null || unitName.isEmpty) {
      return 'units';
    }

    final lowered = unitName.toLowerCase();

    if (lowered == 'kg' || lowered == 'g' || lowered == 'l') {
      return lowered;
    }

    if (quantity == 1) {
      return lowered;
    }

    return lowered.endsWith('s') ? lowered : '${lowered}s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final previewQuantity = _previewQuantity;
    final quantityErrorText = _quantityErrorText;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(_title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(widget.product.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Current: ${_formatQuantity(widget.product.quantity)} ${_unitLabel(widget.product.quantity)}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _quantityController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: _quantityLabel,
                    errorText: quantityErrorText,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    suffixIcon:
                        widget.mode == ProductQuantityAdjustmentMode.consume
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextButton(
                              onPressed: widget.product.quantity > 0
                                  ? _useAllQuantity
                                  : null,
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                minimumSize: const Size(0, 36),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text('Use all'),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  previewQuantity != null
                      ? '$_previewLabel: ${_formatQuantity(previewQuantity)} ${_unitLabel(previewQuantity)}'
                      : '$_previewLabel: --',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                FilledButton(
                  onPressed: _canConfirm ? _confirm : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
