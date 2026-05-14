import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/product_types/presentation/widgets/index.dart';

class ProductTypeListPage extends ConsumerWidget {
  const ProductTypeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productTypesAsync = ref.watch(productTypesStreamProvider);
    final categoriesAsync = ref.watch(watchAllCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Product Types')),
      body: productTypesAsync.when(
        data: (productTypes) {
          if (productTypes.isEmpty) {
            return EmptyProductTypesWidget(
              onCreatePressed: () => _handleCreatePressed(
                context,
                ref,
                categoriesAsync,
              ),
            );
          }

          return ListView.builder(
            itemCount: productTypes.length,
            itemBuilder: (context, index) {
              final productType = productTypes[index];
              return ProductTypeItemWidget(
                productType: productType,
                onTap: () {},
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
                'Error loading product types',
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
        onPressed: () => _handleCreatePressed(context, ref, categoriesAsync),
        tooltip: 'Add Product Type',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleCreatePressed(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<CategoryModel>> categoriesAsync,
  ) {
    categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create a category before adding product types.'),
            ),
          );
          return;
        }

        _showCreateProductTypeDialog(context, ref, categories);
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading categories...')),
        );
      },
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading categories: $error')),
        );
      },
    );
  }

  void _showCreateProductTypeDialog(
    BuildContext context,
    WidgetRef ref,
    List<CategoryModel> categories,
  ) {
    final textController = TextEditingController();
    var selectedCategoryId = categories.first.id;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create Product Type'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Product type name',
                      border: OutlineInputBorder(),
                    ),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories
                        .map(
                          (category) => DropdownMenuItem<int>(
                            value: category.id,
                            child: Text(category.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategoryId = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = textController.text.trim();
                    if (name.isNotEmpty) {
                      try {
                        final viewModel =
                            ref.read(productTypeListViewModelProvider);
                        await viewModel.createProductType(
                          name,
                          selectedCategoryId,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $error')),
                          );
                        }
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
