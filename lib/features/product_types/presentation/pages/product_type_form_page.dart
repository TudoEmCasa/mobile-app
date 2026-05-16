import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/index.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';

class ProductTypeFormPage extends ConsumerStatefulWidget {
  final ProductTypeModel? productType;

  const ProductTypeFormPage({super.key, this.productType});

  @override
  ConsumerState<ProductTypeFormPage> createState() =>
      _ProductTypeFormPageState();
}

class _ProductTypeFormPageState extends ConsumerState<ProductTypeFormPage> {
  late TextEditingController _nameController;
  late FocusNode _nameFocus;
  int? _selectedCategoryId;
  CategoryModel? _selectedCategory;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.productType != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _isEditMode ? widget.productType!.name : '',
    );
    _selectedCategoryId = _isEditMode ? widget.productType!.categoryId : null;
    _selectedCategory = _isEditMode ? widget.productType!.category : null;
    _nameFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.error(context, 'Product type name is required');
      return;
    }

    if (_selectedCategoryId == null) {
      AppSnackbar.error(context, 'Category is required');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(productTypeListViewModelProvider);
      if (_isEditMode) {
        final updatedProductType = widget.productType!.copyWith(
          name: name,
          categoryId: _selectedCategoryId,
        );
        await viewModel.updateProductType(updatedProductType);
      } else {
        await viewModel.createProductType(name, _selectedCategoryId!);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        AppSnackbar.error(context, 'Failed to save product type');
      }
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _selectCategory() async {
    final selectedCategory = await Navigator.of(context).push<CategoryModel>(
      MaterialPageRoute(
        builder: (context) => CategoryListPage(
          selectionMode: true,
          selectionTitle: 'Select Category',
          selectedCategoryId: _selectedCategoryId,
        ),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        _selectedCategory = selectedCategory;
        _selectedCategoryId = selectedCategory.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(watchAllCategoriesProvider);
    final selectedCategoryFromList = categoriesAsync.maybeWhen(
      data: (categories) {
        if (_selectedCategory != null) {
          return _selectedCategory;
        }

        if (_selectedCategoryId == null) {
          return null;
        }

        for (final category in categories) {
          if (category.id == _selectedCategoryId) {
            return category;
          }
        }

        return null;
      },
      orElse: () => _selectedCategory,
    );
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Product Type' : 'Create Product Type'),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(
              child: Text('No categories available. Create a category first.'),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    enabled: !_isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Product type name',
                      hintText: 'e.g., Milk, Cheese',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _isSubmitting ? null : _selectCategory,
                    borderRadius: BorderRadius.circular(8),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: const Icon(Icons.chevron_right),
                      ),
                      child: Text(
                        selectedCategoryFromList != null
                            ? selectedCategoryFromList.name
                            : 'Select category',
                        style: selectedCategoryFromList != null
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            const Center(child: Text('Failed to load categories')),
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
