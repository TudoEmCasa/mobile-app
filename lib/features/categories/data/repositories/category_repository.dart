import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/index.dart';

class CategoryRepository {
  final AppDatabase _db;

  CategoryRepository(this._db);

  /// Creates a new category with the given name.
  ///
  /// Returns the ID of the newly created category.
  Future<int> createCategory(String name) {
    final companion = CategoriesCompanion.insert(name: name);

    return _db.into(_db.categories).insert(companion);
  }

  /// Retrieves a single category by ID (one-time read).
  ///
  /// Returns null if the category does not exist.
  Future<CategoryModel?> getCategoryById(int id) async {
    final query = _db.select(_db.categories)..where((t) => t.id.equals(id));
    final category = await query.getSingleOrNull();

    return category != null ? CategoryModel.fromDrift(category) : null;
  }

  /// Watches a single category by ID (reactive read).
  ///
  /// Returns a stream that emits the category whenever it changes.
  /// Returns null if the category does not exist.
  Stream<CategoryModel?> watchCategoryById(int id) {
    final query = _db.select(_db.categories)..where((t) => t.id.equals(id));

    return query.watchSingleOrNull().map(
      (category) => category != null ? CategoryModel.fromDrift(category) : null,
    );
  }

  /// Retrieves all categories as a reactive stream.
  ///
  /// Categories are sorted alphabetically by name.
  Stream<List<CategoryModel>> watchCategories() {
    final query = (_db.select(_db.categories)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));

    return query.watch().map(
      (categories) => categories.map(CategoryModel.fromDrift).toList(),
    );
  }

  /// Updates an existing category.
  ///
  /// Returns true if the update was successful, false otherwise.
  Future<bool> updateCategory(CategoryModel category) async {
    final companion = category.toCompanion();

    return _db.update(_db.categories).replace(companion);
  }

  /// Deletes a category by ID.
  ///
  /// Returns true if the deletion was successful, false otherwise.
  Future<bool> deleteCategory(int id) async {
    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();

    return true;
  }
}
