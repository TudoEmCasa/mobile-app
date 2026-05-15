import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/tables/product_types.dart';
import 'package:tudo_em_casa/core/database/tables/units.dart';

class Products extends Table {
  @override
  String get tableName => 'products';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  IntColumn get productTypeId => integer().references(ProductTypes, #id)();

  IntColumn get unitId => integer().references(Units, #id)();

  RealColumn get quantity => real()();

  DateTimeColumn get expirationDate => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
}
