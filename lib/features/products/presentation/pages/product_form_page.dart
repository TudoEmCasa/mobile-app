import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/data/providers/product_type_repository_provider.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/index.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/presentation/viewmodels/product_list_viewmodel.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final ProductModel? product;

  const ProductFormPage({super.key, this.product});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  late TextEditingController _nameController;
  int? _selectedProductTypeId;
  ProductTypeModel? _selectedProductType;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _isEditMode ? widget.product!.name : '',
    );
    _selectedProductTypeId = _isEditMode ? widget.product!.productTypeId : null;
    _selectedProductType = _isEditMode ? widget.product!.productType : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

    if (name.isEmpty) {
      AppSnackbar.error(context, 'Product name is required');
      return;
    }

    if (_selectedProductTypeId == null) {
      AppSnackbar.error(context, 'Product type is required');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(productListViewModelProvider);
      if (_isEditMode) {
        final updated = widget.product!.copyWith(
          name: name,
          productTypeId: _selectedProductTypeId,
        );
        await viewModel.updateProduct(updated);
      } else {
        await viewModel.createProduct(
          ProductModel.create(
            name: name,
            productTypeId: _selectedProductTypeId!,
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
    final productTypesAsync = ref.watch(watchAllProductTypesProvider);
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
        child: SafeArea(
          top: false,
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
