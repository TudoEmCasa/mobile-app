import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';

class ProductModel {
  final int id;
  final String name;
  final int productTypeId;
  final int unitId;
  final double quantity;
  final DateTime? expirationDate;
  final DateTime createdAt;

  final ProductTypeModel? productType;
  final UnitModel? unit;

  ProductModel({
    required this.id,
    required this.name,
    required this.productTypeId,
    required this.unitId,
    required this.quantity,
    required this.expirationDate,
    required this.createdAt,
    this.productType,
    this.unit,
  });

  factory ProductModel.create({
    required String name,
    required int productTypeId,
    required int unitId,
    required double quantity,
    DateTime? expirationDate,
  }) {
    return ProductModel(
      id: 0,
      name: name,
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: quantity,
      expirationDate: expirationDate,
      createdAt: DateTime.now(),
      productType: null,
      unit: null,
    );
  }

  factory ProductModel.fromDrift(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      productTypeId: product.productTypeId,
      unitId: product.unitId,
      quantity: product.quantity,
      expirationDate: product.expirationDate,
      createdAt: product.createdAt,
    );
  }

  ProductsCompanion toCompanion({bool insertingNew = false}) {
    return ProductsCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
      productTypeId: Value(productTypeId),
      unitId: Value(unitId),
      quantity: Value(quantity),
      expirationDate: Value(expirationDate),
      createdAt: Value(createdAt),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? productTypeId,
    int? unitId,
    double? quantity,
    DateTime? expirationDate,
    DateTime? createdAt,
    ProductTypeModel? productType,
    UnitModel? unit,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      productTypeId: productTypeId ?? this.productTypeId,
      unitId: unitId ?? this.unitId,
      quantity: quantity ?? this.quantity,
      expirationDate: expirationDate ?? this.expirationDate,
      createdAt: createdAt ?? this.createdAt,
      productType: productType ?? this.productType,
      unit: unit ?? this.unit,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          productTypeId == other.productTypeId &&
          unitId == other.unitId &&
          quantity == other.quantity &&
          expirationDate == other.expirationDate &&
          createdAt == other.createdAt &&
          productType == other.productType &&
          unit == other.unit;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      productTypeId.hashCode ^
      unitId.hashCode ^
      quantity.hashCode ^
      (expirationDate?.hashCode ?? 0) ^
      createdAt.hashCode ^
      (productType?.hashCode ?? 0) ^
      (unit?.hashCode ?? 0);

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, productTypeId: $productTypeId, unitId: $unitId, quantity: $quantity, expirationDate: $expirationDate, createdAt: $createdAt, productType: $productType, unit: $unit)';
}
