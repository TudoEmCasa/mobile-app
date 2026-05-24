import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/exceptions/product_quantity_consumption_exception.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';

class LotRepository {
  final AppDatabase _db;

  LotRepository(this._db);

  Future<int> createLot(LotModel lot) {
    return _db.into(_db.lots).insert(lot.toCompanion(insertingNew: true));
  }

  Future<LotModel?> getLotById(int id) async {
    final query = _db.select(_db.lots).join([
      leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.lots.unitId)),
    ])..where(_db.lots.id.equals(id));

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _mapRow(row);
  }

  Future<List<LotModel>> getLots() async {
    final query =
        _db.select(_db.lots).join([
          leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.lots.unitId)),
        ])..orderBy([
          OrderingTerm(expression: _db.lots.productId, mode: OrderingMode.asc),
          OrderingTerm(expression: _db.lots.id, mode: OrderingMode.asc),
        ]);

    final rows = await query.get();

    return rows.map(_mapRow).toList();
  }

  Future<List<LotModel>> getLotsByProductId(int productId) async {
    final query =
        _db.select(_db.lots).join([
            leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.lots.unitId)),
          ])
          ..where(_db.lots.productId.equals(productId))
          ..orderBy([
            OrderingTerm(expression: _db.lots.id, mode: OrderingMode.asc),
          ]);

    final rows = await query.get();

    return rows.map(_mapRow).toList();
  }

  Future<void> clearLots() async {
    await _db.delete(_db.lots).go();
  }

  Future<void> insertLots(List<LotModel> lots) async {
    if (lots.isEmpty) {
      return;
    }

    await _db.batch((batch) {
      batch.insertAll(
        _db.lots,
        lots.map((lot) => lot.toCompanion(insertingNew: lot.id == 0)).toList(),
      );
    });
  }

  Future<bool> updateLot(LotModel lot) async {
    return _db.update(_db.lots).replace(lot.toCompanion());
  }

  Future<bool> deleteLot(int id) async {
    await (_db.delete(_db.lots)..where((t) => t.id.equals(id))).go();
    return true;
  }

  Future<LotModel> addLotQuantity({
    required int lotId,
    required double quantity,
  }) async {
    if (!quantity.isFinite || quantity <= 0) {
      throw const ProductQuantityConsumptionException(
        'Quantity must be greater than zero',
      );
    }

    return _db.transaction(() async {
      final currentLot = await getLotById(lotId);

      if (currentLot == null) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      await updateLot(
        currentLot.copyWith(quantity: currentLot.quantity + quantity),
      );

      final updatedLot = await getLotById(lotId);

      if (updatedLot == null) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      return updatedLot;
    });
  }

  Future<LotModel> consumeLotQuantity({
    required int lotId,
    required double quantity,
  }) async {
    if (!quantity.isFinite || quantity <= 0) {
      throw const ProductQuantityConsumptionException(
        'Quantity must be greater than zero',
      );
    }

    return _db.transaction(() async {
      final currentLot = await getLotById(lotId);

      if (currentLot == null) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      if (quantity > currentLot.quantity) {
        throw const ProductQuantityConsumptionException(
          'Insufficient quantity',
        );
      }

      await updateLot(
        currentLot.copyWith(quantity: currentLot.quantity - quantity),
      );

      final updatedLot = await getLotById(lotId);

      if (updatedLot == null) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      return updatedLot;
    });
  }

  Stream<List<LotModel>> watchLotsByProductId(int productId) {
    final query =
        _db.select(_db.lots).join([
            leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.lots.unitId)),
          ])
          ..where(_db.lots.productId.equals(productId))
          ..orderBy([
            OrderingTerm(expression: _db.lots.id, mode: OrderingMode.asc),
          ]);

    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  Stream<List<LotModel>> watchLots() {
    final query =
        _db.select(_db.lots).join([
          leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.lots.unitId)),
        ])..orderBy([
          OrderingTerm(expression: _db.lots.productId, mode: OrderingMode.asc),
          OrderingTerm(expression: _db.lots.id, mode: OrderingMode.asc),
        ]);

    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  LotModel _mapRow(TypedResult row) {
    final lot = row.readTable(_db.lots);
    final unit = row.readTableOrNull(_db.units);

    return LotModel(
      id: lot.id,
      productId: lot.productId,
      unitId: lot.unitId,
      quantity: lot.quantity,
      expirationDate: lot.expirationDate,
      unit: unit != null ? UnitModel.fromDrift(unit) : null,
    );
  }
}
