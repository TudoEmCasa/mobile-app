import 'dart:async';

import 'package:tudo_em_casa/features/categories/data/models/index.dart';

class CategoryRepository {
  final List<CategoryModel> _categories = <CategoryModel>[];
  final StreamController<List<CategoryModel>> _controller =
      StreamController<List<CategoryModel>>.broadcast();
  int _nextId = 1;

  CategoryRepository() {
    _emit();
  }

  Future<int> createCategory(String name) async {
    final category = CategoryModel(id: _nextId++, name: name);
    _categories.add(category);
    _emit();
    return category.id;
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }

    return null;
  }

  Stream<CategoryModel?> watchCategoryById(int id) {
    return watchCategories().map((categories) {
      for (final category in categories) {
        if (category.id == id) {
          return category;
        }
      }

      return null;
    });
  }

  Stream<List<CategoryModel>> watchCategories() {
    return () async* {
      yield List<CategoryModel>.unmodifiable(_categories);
      yield* _controller.stream;
    }();
  }

  Future<bool> updateCategory(CategoryModel category) async {
    final index = _categories.indexWhere((item) => item.id == category.id);

    if (index == -1) {
      return false;
    }

    _categories[index] = category;
    _emit();
    return true;
  }

  Future<bool> deleteCategory(int id) async {
    final initialLength = _categories.length;
    _categories.removeWhere((category) => category.id == id);
    _emit();
    return _categories.length != initialLength;
  }

  void _emit() {
    _controller.add(List<CategoryModel>.unmodifiable(_categories));
  }
}
