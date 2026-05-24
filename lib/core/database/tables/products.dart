import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/tables/product_types.dart';

class Products extends Table {
  @override
  String get tableName => 'products';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get productTypeId => integer().references(ProductTypes, #id)();
}
