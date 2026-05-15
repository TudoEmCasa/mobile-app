import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';

class UnitRepository {
  final AppDatabase _db;

  UnitRepository(this._db);

  Future<int> createUnit(String name, String symbol) {
    final companion = UnitsCompanion.insert(name: name, symbol: symbol);
    return _db.into(_db.units).insert(companion);
  }

  Future<UnitModel?> getUnitById(int id) async {
    final query = _db.select(_db.units)..where((t) => t.id.equals(id));
    final unit = await query.getSingleOrNull();

    return unit != null ? UnitModel.fromDrift(unit) : null;
  }

  Stream<UnitModel?> watchUnitById(int id) {
    final query = _db.select(_db.units)..where((t) => t.id.equals(id));

    return query.watchSingleOrNull().map(
      (unit) => unit != null ? UnitModel.fromDrift(unit) : null,
    );
  }

  Stream<List<UnitModel>> watchUnits() {
    final query = (_db.select(_db.units)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));

    return query.watch().map(
      (units) => units.map(UnitModel.fromDrift).toList(),
    );
  }

  Future<bool> updateUnit(UnitModel unit) async {
    final companion = unit.toCompanion();

    return _db.update(_db.units).replace(companion);
  }

  Future<bool> deleteUnit(int id) async {
    await (_db.delete(_db.units)..where((t) => t.id.equals(id))).go();

    return true;
  }
}
