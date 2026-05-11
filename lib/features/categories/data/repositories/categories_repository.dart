import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';

/// Repository responsible for persistence of categories.
/// Keeps business rules out of this layer; only data access logic lives here.
class CategoriesRepository {
  final AppDatabase _db;

  CategoriesRepository(this._db);

  /// Inserts a new category and returns the inserted row id.
  Future<int> createCategory(String name, {String? description}) {
    final companion = CategoriesCompanion.insert(
      name: name,
      description: Value(description),
    );

    return _db.into(_db.categories).insert(companion);
  }

  /// Watches categories ordered alphabetically by name.
  Stream<List<Category>> watchCategories() {
    final query = (_db.select(_db.categories)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));

    return query.watch();
  }
}
