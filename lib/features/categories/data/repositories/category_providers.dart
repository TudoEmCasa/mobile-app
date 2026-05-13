import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository_provider.dart';

/// Provides a reactive stream of all categories.
///
/// This provider watches all categories from the repository and updates
/// whenever the database changes.
final watchAllCategoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);

  return repository.watchCategories();
});
