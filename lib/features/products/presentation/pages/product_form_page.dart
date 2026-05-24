import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/utils/date_formatter.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/data/providers/product_type_repository_provider.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/index.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_list_viewmodel.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/providers/unit_repository_provider.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/index.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  int? _selectedProductTypeId;
  ProductTypeModel? _selectedProductType;
  int? _selectedUnitId;
  UnitModel? _selectedUnit;
  DateTime? _expirationDate;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.product != null;

  LotModel? get _initialLot {
    final lots = widget.product?.lots;

    if (lots == null || lots.isEmpty) {
      return null;
    }

    return lots.first;
  }

  @override
  void initState() {
    super.initState();
    final initialLot = _initialLot;
    _nameController = TextEditingController(
      text: _isEditMode ? widget.product!.name : '',
    );
    _quantityController = TextEditingController(
      text: initialLot != null ? initialLot.quantity.toString() : '0',
    );
    _selectedProductTypeId = _isEditMode ? widget.product!.productTypeId : null;
    _selectedProductType = _isEditMode ? widget.product!.productType : null;
    _selectedUnitId = initialLot?.unitId;
    _selectedUnit = initialLot?.unit;
    _expirationDate = initialLot?.expirationDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
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

  Future<void> _selectUnit() async {
    final selectedUnit = await Navigator.of(context).push<UnitModel>(
      MaterialPageRoute(
        builder: (context) => UnitListPage(
          selectionMode: true,
          selectionTitle: 'Select Unit',
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

  Future<void> _selectProductType() async {
    final selectedProductType = await Navigator.of(context)
        .push<ProductTypeModel>(
          MaterialPageRoute(
            builder: (context) => ProductTypeListPage(
              selectionMode: true,
              selectionTitle: 'Select Product Type',
              selectedProductTypeId: _selectedProductTypeId,
            ),
          ),
        );

    if (selectedProductType != null) {
      setState(() {
        _selectedProductType = selectedProductType;
        _selectedProductTypeId = selectedProductType.id;
      });
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0.0;

    if (name.isEmpty) {
      AppSnackbar.error(context, 'Product name is required');
      return;
    }

    if (quantity <= 0) {
      AppSnackbar.error(context, 'Quantity must be greater than zero');
      return;
    }

    if (_selectedProductTypeId == null) {
      AppSnackbar.error(context, 'Product type is required');
      return;
    }

    if (_selectedUnitId == null) {
      AppSnackbar.error(context, 'Unit is required');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(productListViewModelProvider);
      final lot = LotModel.create(
        productId: widget.product?.id ?? 0,
        unitId: _selectedUnitId!,
        quantity: quantity,
        expirationDate: _expirationDate,
      ).copyWith(unit: _selectedUnit);

      if (_isEditMode) {
        final updated = widget.product!.copyWith(
          name: name,
          productTypeId: _selectedProductTypeId,
          lots: [
            lot.copyWith(
              id: _initialLot?.id ?? 0,
              productId: widget.product!.id,
            ),
          ],
        );
        await viewModel.updateProduct(updated);
      } else {
        await viewModel.createProduct(
          ProductModel.create(
            name: name,
            productTypeId: _selectedProductTypeId!,
            lots: [lot],
          ),
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to save product');
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    final productTypesAsync = ref.watch(watchAllProductTypesProvider);
    final unitsAsync = ref.watch(watchAllUnitsProvider);
    final selectedProductTypeFromList = productTypesAsync.maybeWhen(
      data: (productTypes) {
        if (_selectedProductType != null) {
          return _selectedProductType;
        }

        if (_selectedProductTypeId == null) {
          return null;
        }

        for (final productType in productTypes) {
          if (productType.id == _selectedProductTypeId) {
            return productType;
          }
        }

        return null;
      },
      orElse: () => _selectedProductType,
    );
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product' : 'Create Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _isSubmitting ? null : _selectUnit,
                      borderRadius: BorderRadius.circular(8),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: const Icon(Icons.chevron_right),
                        ),
                        child: Text(
                          selectedUnitFromList != null
                              ? '${selectedUnitFromList.symbol} - ${selectedUnitFromList.name}'
                              : 'Select unit',
                          style: selectedUnitFromList != null
                              ? null
                              : Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).hintColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _isSubmitting ? null : _selectProductType,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Product type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.chevron_right),
                  ),
                  child: Text(
                    selectedProductTypeFromList != null
                        ? selectedProductTypeFromList.name
                        : 'Select product type',
                    style: selectedProductTypeFromList != null
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
                            ? DateFormatter.formatDate(_expirationDate!)
                            : 'Select expiration date',
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: SafeArea(
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
                  : Text(_isEditMode ? 'Update' : 'Create'),
            ),
          ),
        ),
      ),
    );
  }
}
