import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart'
    if (dart.library.html) 'package:tudo_em_casa/features/categories/data/repositories/category_repository_web.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/index.dart';

/// Provides access to category repository methods for the UI layer.
///
/// This exposes repository methods in a convenient way for ViewModels
/// and Pages to call.
final categoryServiceProvider = Provider((ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return CategoryService(repository);
});

/// Service for category operations.
///
/// Delegates to the repository and provides a clean interface for ViewModels.
class CategoryService {
  final CategoryRepository _repository;

  CategoryService(this._repository);

  /// Creates a new category with the given name.
  Future<int> createCategory(String name) {
    return _repository.createCategory(name);
  }

  /// Deletes a category by ID.
  Future<bool> deleteCategory(int id) {
    return _repository.deleteCategory(id);
  }
}
