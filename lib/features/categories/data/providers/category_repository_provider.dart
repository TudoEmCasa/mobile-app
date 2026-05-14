import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';

/// Provides a singleton instance of [CategoryRepository].
///
/// This provider manages the repository lifecycle and ensures
/// a single instance is shared across the application.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return CategoryRepository(database);
});

/// Provides a reactive stream of all categories.
///
/// This provider watches all categories from the repository and updates
/// whenever the database changes. Categories are sorted alphabetically by name.
final watchAllCategoriesProvider = StreamProvider<List<CategoryModel>>((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.watchCategories();
});
