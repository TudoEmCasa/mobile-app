import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';

class LotModel {
  final int id;
  final int productId;
  final int unitId;
  final double quantity;
  final DateTime? expirationDate;
  final UnitModel? unit;

  LotModel({
    required this.id,
    required this.productId,
    required this.unitId,
    required this.quantity,
    required this.expirationDate,
    this.unit,
  });

  factory LotModel.create({
    required int productId,
    required int unitId,
    required double quantity,
    DateTime? expirationDate,
  }) {
    return LotModel(
      id: 0,
      productId: productId,
      unitId: unitId,
      quantity: quantity,
      expirationDate: expirationDate,
      unit: null,
    );
  }

  factory LotModel.fromDrift(Lot lot) {
    return LotModel(
      id: lot.id,
      productId: lot.productId,
      unitId: lot.unitId,
      quantity: lot.quantity,
      expirationDate: lot.expirationDate,
    );
  }

  factory LotModel.fromJson(Map<String, Object?> json) {
    return LotModel(
      id: (json['id'] as num).toInt(),
      productId: (json['productId'] as num).toInt(),
      unitId: (json['unitId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      unit: json['unit'] is Map<String, Object?>
          ? UnitModel.fromJson(json['unit'] as Map<String, Object?>)
          : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'productId': productId,
      'unitId': unitId,
      'quantity': quantity,
      'expirationDate': expirationDate?.toIso8601String(),
      if (unit != null) 'unit': unit!.toJson(),
    };
  }

  LotsCompanion toCompanion({bool insertingNew = false}) {
    return LotsCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      productId: Value(productId),
      unitId: Value(unitId),
      quantity: Value(quantity),
      expirationDate: Value(expirationDate),
    );
  }

  LotModel copyWith({
    int? id,
    int? productId,
    int? unitId,
    double? quantity,
    DateTime? expirationDate,
    UnitModel? unit,
  }) {
    return LotModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      quantity: quantity ?? this.quantity,
      expirationDate: expirationDate ?? this.expirationDate,
      unit: unit ?? this.unit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LotModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          productId == other.productId &&
          unitId == other.unitId &&
          quantity == other.quantity &&
          expirationDate == other.expirationDate &&
          unit == other.unit;

  @override
  int get hashCode =>
      id.hashCode ^
      productId.hashCode ^
      unitId.hashCode ^
      quantity.hashCode ^
      (expirationDate?.hashCode ?? 0) ^
      (unit?.hashCode ?? 0);

  @override
  String toString() {
    return 'LotModel(id: $id, productId: $productId, unitId: $unitId, quantity: $quantity, expirationDate: $expirationDate, unit: $unit)';
  }
}
