import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/tables/products.dart';
import 'package:tudo_em_casa/core/database/tables/units.dart';

class Lots extends Table {
  @override
  String get tableName => 'lots';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get productId =>
      integer().references(Products, #id, onDelete: KeyAction.cascade)();

  IntColumn get unitId => integer().references(Units, #id)();

  RealColumn get quantity => real()();

  DateTimeColumn get expirationDate => dateTime().nullable()();
}
