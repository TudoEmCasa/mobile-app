import 'package:drift/drift.dart';

class Units extends Table {
  @override
  String get tableName => 'units';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();

  TextColumn get symbol => text()();
}
