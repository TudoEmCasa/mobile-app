import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';

/// ViewModel for the category list presentation.
///
/// Manages the business logic for displaying and manipulating categories.
/// Exposes reactive state through Riverpod providers.
class CategoryListViewModel {
  final Ref _ref;

  CategoryListViewModel(this._ref);

  /// Creates a new category with the given name.
  ///
  /// Returns the ID of the newly created category.
  Future<int> createCategory(String name) {
    final repository = _ref.read(categoryRepositoryProvider);
    return repository.createCategory(name);
  }

  /// Deletes a category by ID.
  ///
  /// Returns true if the deletion was successful.
  Future<bool> deleteCategory(int id) {
    final repository = _ref.read(categoryRepositoryProvider);
    return repository.deleteCategory(id);
  }
}

/// Provides an instance of [CategoryListViewModel].
///
/// This provider ensures a single ViewModel instance is used per consumer.
final categoryListViewModelProvider = Provider<CategoryListViewModel>((ref) {
  return CategoryListViewModel(ref);
});

/// Provides a reactive stream of all categories.
///
/// This is exposed at the ViewModel level for the UI layer to consume.
final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref.watch(watchAllCategoriesProvider).when(
    data: (categories) async* {
      yield categories;
    },
    loading: () async* {
      yield const [];
    },
    error: (error, stackTrace) {
      throw error;
    },
  );
});
