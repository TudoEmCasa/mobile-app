import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';

class CategoryRepository {
  final AppDatabase _db;

  CategoryRepository(this._db);

  Future<int> createCategory(String name) {
    final companion = CategoriesCompanion.insert(name: name);

    return _db.into(_db.categories).insert(companion);
  }

  Future<CategoryModel?> getCategoryById(int id) async {
    final query = _db.select(_db.categories)..where((t) => t.id.equals(id));
    final category = await query.getSingleOrNull();

    return category != null ? CategoryModel.fromDrift(category) : null;
  }

  Future<List<CategoryModel>> getCategories() async {
    final query = (_db.select(_db.categories)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));
    final categories = await query.get();

    return categories.map(CategoryModel.fromDrift).toList();
  }

  Stream<CategoryModel?> watchCategoryById(int id) {
    final query = _db.select(_db.categories)..where((t) => t.id.equals(id));

    return query.watchSingleOrNull().map(
      (category) => category != null ? CategoryModel.fromDrift(category) : null,
    );
  }

  Stream<List<CategoryModel>> watchCategories() {
    final query = (_db.select(_db.categories)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));

    return query.watch().map(
      (categories) => categories.map(CategoryModel.fromDrift).toList(),
    );
  }

  Future<bool> updateCategory(CategoryModel category) async {
    final companion = category.toCompanion();

    return _db.update(_db.categories).replace(companion);
  }

  Future<bool> deleteCategory(int id) async {
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();

    return true;
  }
}
