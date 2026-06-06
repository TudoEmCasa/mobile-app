import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

enum LotQuantityAdjustmentMode { add, consume }

Future<double?> showLotQuantityAdjustmentBottomSheet({
  required BuildContext context,
  required LotModel lot,
  required LotQuantityAdjustmentMode mode,
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
      return _LotQuantityAdjustmentSheet(lot: lot, mode: mode);
    },
  );
}

Future<double?> showLotQuantityConsumptionBottomSheet({
  required BuildContext context,
  required LotModel lot,
}) {
  return showLotQuantityAdjustmentBottomSheet(
    context: context,
    lot: lot,
    mode: LotQuantityAdjustmentMode.consume,
  );
}

class _LotQuantityAdjustmentSheet extends StatefulWidget {
  final LotModel lot;
  final LotQuantityAdjustmentMode mode;

  const _LotQuantityAdjustmentSheet({required this.lot, required this.mode});

  @override
  State<_LotQuantityAdjustmentSheet> createState() =>
      _LotQuantityAdjustmentSheetState();
}

class _LotQuantityAdjustmentSheetState
    extends State<_LotQuantityAdjustmentSheet> {
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

  double get _currentQuantity => widget.lot.quantity;

  String? get _quantityErrorText {
    final text = _quantityController.text.trim();

    if (text.isEmpty) {
      return context.l10n.text('enterQuantity');
    }

    final quantity = double.tryParse(text);

    if (quantity == null || !quantity.isFinite) {
      return context.l10n.text('enterValidQuantity');
    }

    if (quantity <= 0) {
      return context.l10n.text('quantityMustBeGreaterThanZero');
    }

    if (widget.mode == LotQuantityAdjustmentMode.consume &&
        quantity > _currentQuantity) {
      return context.l10n.text('insufficientQuantity');
    }

    return null;
  }

  double? get _previewQuantity {
    final enteredQuantity = _enteredQuantity;

    if (enteredQuantity == null) {
      return null;
    }

    return widget.mode == LotQuantityAdjustmentMode.consume
        ? _currentQuantity - enteredQuantity
        : _currentQuantity + enteredQuantity;
  }

  bool get _canConfirm => _quantityErrorText == null;

  String get _title {
    return widget.mode == LotQuantityAdjustmentMode.consume
        ? context.l10n.text('consumeQuantity')
        : context.l10n.text('addQuantity');
  }

  String get _quantityLabel {
    return widget.mode == LotQuantityAdjustmentMode.consume
        ? context.l10n.text('quantityToUse')
        : context.l10n.text('quantityToAdd');
  }

  String get _previewLabel {
    return widget.mode == LotQuantityAdjustmentMode.consume
        ? context.l10n.text('remaining')
        : context.l10n.text('newTotal');
  }

  void _useAllQuantity() {
    if (widget.mode != LotQuantityAdjustmentMode.consume) {
      return;
    }

    final quantityText = _formatQuantity(_currentQuantity);

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
    final unitName = widget.lot.unit?.name.trim();

    if (unitName == null || unitName.isEmpty) {
      return context.l10n.text('unitsFallback');
    }

    final lowered = unitName.toLowerCase();

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
                Text(
                  widget.lot.unit?.name ?? context.l10n.text('lotFallback'),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.withQuantityAndUnit(
                    'currentQuantity',
                    _formatQuantity(_currentQuantity),
                    _unitLabel(_currentQuantity),
                  ),
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
                    suffixIcon: widget.mode == LotQuantityAdjustmentMode.consume
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: TextButton(
                              onPressed: _currentQuantity > 0
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
                              child: Text(context.l10n.text('useAll')),
                            ),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  previewQuantity != null
                      ? context.l10n.withPreview(
                          'previewQuantity',
                          _previewLabel,
                          _formatQuantity(previewQuantity),
                          _unitLabel(previewQuantity),
                        )
                      : context.l10n.withLabel(
                          'emptyPreviewQuantity',
                          _previewLabel,
                        ),
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
                  child: Text(context.l10n.text('confirm')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
