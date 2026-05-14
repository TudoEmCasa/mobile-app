import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/tables/categories.dart';

class ProductTypes extends Table {
  @override
  String get tableName => 'product_types';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get categoryId => integer().references(Categories, #id)();
}
