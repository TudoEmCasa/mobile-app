import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';
import 'package:tudo_em_casa/features/categories/data/providers/index.dart';

class CategoryListViewModel {
  final Ref _ref;

  CategoryListViewModel(this._ref);

  Future<int> createCategory(String name) {
    final repository = _ref.read(categoryRepositoryProvider);
    return repository.createCategory(name);
  }

  Future<bool> updateCategory(CategoryModel category) {
    final repository = _ref.read(categoryRepositoryProvider);
    return repository.updateCategory(category);
  }

  Future<bool> deleteCategory(int id) {
    final repository = _ref.read(categoryRepositoryProvider);
    return repository.deleteCategory(id);
  }
}

final categoryListViewModelProvider = Provider<CategoryListViewModel>((ref) {
  return CategoryListViewModel(ref);
});

final categoriesStreamProvider = StreamProvider<List<CategoryModel>>((ref) {
  return ref
      .watch(watchAllCategoriesProvider)
      .when(
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
