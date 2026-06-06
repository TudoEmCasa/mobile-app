import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/index.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

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
      AppSnackbar.error(context, context.l10n.text('productTypeNameRequired'));
      return;
    }

    if (_selectedCategoryId == null) {
      AppSnackbar.error(context, context.l10n.text('categoryRequired'));
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
        AppSnackbar.error(
          context,
          context.l10n.text('failedToSaveProductType'),
        );
      }
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _selectCategory() async {
    final selectedCategory = await Navigator.of(context).push<CategoryModel>(
      MaterialPageRoute(
        builder: (context) => CategoryListPage(
          selectionMode: true,
          selectionTitle: context.l10n.text('selectCategory'),
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
        title: Text(
          _isEditMode
              ? context.l10n.text('editProductType')
              : context.l10n.text('createProductType'),
        ),
      ),
      body: SafeArea(
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
                  labelText: context.l10n.text('productTypeName'),
                  hintText: context.l10n.text('productTypeNameHint'),
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
                    labelText: context.l10n.text('categoryLabel'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.chevron_right),
                  ),
                  child: Text(
                    selectedCategoryFromList != null
                        ? selectedCategoryFromList.name
                        : context.l10n.text('selectCategoryLower'),
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
                  : Text(
                      _isEditMode
                          ? context.l10n.text('update')
                          : context.l10n.text('create'),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
