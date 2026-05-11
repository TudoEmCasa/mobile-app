import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';

class CategoriesRepository {
  final AppDatabase _db;

  CategoriesRepository(this._db);

  Future<int> createCategory(String name, {String? icon, String? color}) {
    final companion = CategoriesCompanion.insert(
      name: name,
      icon: Value(icon),
      color: Value(color),
    );

    return _db.into(_db.categories).insert(companion);
  }

  Stream<List<Category>> watchCategories() {
    final query = (_db.select(_db.categories)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));

    return query.watch();
  }
}
