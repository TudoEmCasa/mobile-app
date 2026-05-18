import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/category_form_page.dart';
import 'package:tudo_em_casa/features/categories/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/widgets/index.dart';

class CategoryListPage extends ConsumerStatefulWidget {
  final bool selectionMode;
  final String selectionTitle;
  final int? selectedCategoryId;

  const CategoryListPage({
    super.key,
    this.selectionMode = false,
    this.selectionTitle = 'Select Category',
    this.selectedCategoryId,
  });

  @override
  ConsumerState<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends ConsumerState<CategoryListPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(watchAllCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectionMode ? widget.selectionTitle : 'Categories',
        ),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          clearLoadErrorFeedback();

          if (categories.isEmpty) {
            return EmptyCategoriesWidget(
              onCreatePressed: () => _navigateToCategoryForm(context),
            );
          }

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryItemWidget(
                category: category,
                selectable: widget.selectionMode,
                selected: category.id == widget.selectedCategoryId,
                onSelected: widget.selectionMode
                    ? (selectedCategory) =>
                          Navigator.of(context).pop(selectedCategory)
                    : null,
                onEdit: () => _navigateToCategoryForm(context, category),
                onDelete: () => _handleDeleteCategory(context, ref, category),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          showLoadErrorFeedback('Failed to load categories');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Failed to load categories',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCategoryForm(context),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToCategoryForm(
    BuildContext context, [
    CategoryModel? category,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => CategoryFormPage(category: category),
      ),
    );

    if (saved == true && context.mounted) {
      AppSnackbar.success(
        context,
        category == null ? 'Category created' : 'Category updated',
      );
    }
  }

  Future<void> _handleDeleteCategory(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) async {
    final shouldDelete = await showAppConfirmationBottomSheet(
      context: context,
      title: 'Delete Category?',
      message: 'Delete "${category.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(categoryListViewModelProvider);
      await viewModel.deleteCategory(category.id);
      if (context.mounted) {
        AppSnackbar.success(context, 'Category removed');
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Failed to delete category');
      }
    }
  }
}
