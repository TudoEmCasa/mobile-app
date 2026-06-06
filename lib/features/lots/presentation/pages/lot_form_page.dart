import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/utils/date_formatter.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/lots/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/providers/unit_repository_provider.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class LotFormPage extends ConsumerStatefulWidget {
  final ProductModel product;
  final LotModel? lot;

  const LotFormPage({super.key, required this.product, this.lot});

  @override
  ConsumerState<LotFormPage> createState() => _LotFormPageState();
}

class _LotFormPageState extends ConsumerState<LotFormPage> {
  late final TextEditingController _quantityController;
  int? _selectedUnitId;
  UnitModel? _selectedUnit;
  DateTime? _expirationDate;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.lot != null;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.lot?.quantity.toString() ?? '',
    );
    _selectedUnitId = widget.lot?.unitId;
    _selectedUnit = widget.lot?.unit;
    _expirationDate = widget.lot?.expirationDate;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectUnit() async {
    final selectedUnit = await Navigator.of(context).push<UnitModel>(
      MaterialPageRoute(
        builder: (context) => UnitListPage(
          selectionMode: true,
          selectionTitle: context.l10n.text('selectUnit'),
          selectedUnitId: _selectedUnitId,
        ),
      ),
    );

    if (selectedUnit != null) {
      setState(() {
        _selectedUnit = selectedUnit;
        _selectedUnitId = selectedUnit.id;
      });
    }
  }

  Future<void> _pickExpirationDate() async {
    final now = DateTime.now();
    final initial = _expirationDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(
        () => _expirationDate = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }

  Future<void> _handleSave() async {
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;

    if (quantity <= 0) {
      AppSnackbar.error(
        context,
        context.l10n.text('quantityMustBeGreaterThanZero'),
      );
      return;
    }

    if (_selectedUnitId == null) {
      AppSnackbar.error(context, context.l10n.text('unitRequired'));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(lotListViewModelProvider);

      if (_isEditMode) {
        await viewModel.updateLot(
          widget.lot!.copyWith(
            productId: widget.product.id,
            unitId: _selectedUnitId,
            quantity: quantity,
            expirationDate: _expirationDate,
            unit: _selectedUnit,
          ),
        );
      } else {
        await viewModel.createLot(
          LotModel.create(
            productId: widget.product.id,
            unitId: _selectedUnitId!,
            quantity: quantity,
            expirationDate: _expirationDate,
          ).copyWith(unit: _selectedUnit),
        );
      }

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToSaveLot'));
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(watchAllUnitsProvider);
    final selectedUnitFromList = unitsAsync.maybeWhen(
      data: (units) {
        if (_selectedUnit != null) {
          return _selectedUnit;
        }

        if (_selectedUnitId == null) {
          return null;
        }

        for (final unit in units) {
          if (unit.id == _selectedUnitId) {
            return unit;
          }
        }

        return null;
      },
      orElse: () => _selectedUnit,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? context.l10n.text('editLot')
              : context.l10n.text('createLot'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.withName(
                  'productTypeWithName',
                  widget.product.productType?.name ??
                      context.l10n.text('unknown'),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.text('quantity'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _isSubmitting ? null : _selectUnit,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.l10n.text('unitLabel'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.chevron_right),
                  ),
                  child: Text(
                    selectedUnitFromList != null
                        ? '${selectedUnitFromList.symbol} - ${selectedUnitFromList.name}'
                        : context.l10n.text('selectUnitLower'),
                    style: selectedUnitFromList != null
                        ? null
                        : Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickExpirationDate,
                      child: Text(
                        _expirationDate != null
                            ? DateFormatter.formatDate(
                                _expirationDate!,
                                locale: Localizations.localeOf(
                                  context,
                                ).toString(),
                              )
                            : context.l10n.text('selectExpirationDate'),
                      ),
                    ),
                  ),
                  if (_expirationDate != null)
                    IconButton(
                      onPressed: () => setState(() => _expirationDate = null),
                      icon: const Icon(Icons.clear),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSave,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _isEditMode
                        ? context.l10n.text('update')
                        : context.l10n.text('create'),
                  ),
          ),
        ),
      ),
    );
  }
}
