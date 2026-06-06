import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class CategoryFormPage extends ConsumerStatefulWidget {
  final CategoryModel? category;

  const CategoryFormPage({super.key, this.category});

  @override
  ConsumerState<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends ConsumerState<CategoryFormPage> {
  late TextEditingController _nameController;
  late FocusNode _nameFocus;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _isEditMode ? widget.category!.name : '',
    );
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
      AppSnackbar.error(context, context.l10n.text('categoryNameRequired'));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(categoryListViewModelProvider);
      if (_isEditMode) {
        final updatedCategory = widget.category!.copyWith(name: name);
        await viewModel.updateCategory(updatedCategory);
      } else {
        await viewModel.createCategory(name);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToSaveCategory'));
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? context.l10n.text('editCategory')
              : context.l10n.text('createCategory'),
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
                  labelText: context.l10n.text('categoryName'),
                  hintText: context.l10n.text('categoryNameHint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _isSubmitting ? null : _handleSave(),
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
