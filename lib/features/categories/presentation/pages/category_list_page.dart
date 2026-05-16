import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/category_form_page.dart';
import 'package:tudo_em_casa/features/categories/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/categories/presentation/widgets/index.dart';

class CategoryListPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(watchAllCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectionMode ? selectionTitle : 'Categories'),
      ),
      body: categoriesAsync.when(
        data: (categories) {
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
                selectable: selectionMode,
                selected: category.id == selectedCategoryId,
                onSelected: selectionMode
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
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Error loading categories',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToCategoryForm(context),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToCategoryForm(
    BuildContext context, [
    CategoryModel? category,
  ]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CategoryFormPage(category: category),
      ),
    );
  }

  void _handleDeleteCategory(
    BuildContext context,
    WidgetRef ref,
    CategoryModel category,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Category?'),
          content: Text(
            'Delete "${category.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final viewModel = ref.read(categoryListViewModelProvider);
                  await viewModel.deleteCategory(category.id);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting category: $error'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
