import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/lots/data/models/lot_model.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';

class ProductModel {
  final int id;
  final String name;
  final int productTypeId;

  final ProductTypeModel? productType;
  final List<LotModel>? lots;

  ProductModel({
    required this.id,
    required this.name,
    required this.productTypeId,
    this.productType,
    this.lots,
  });

  factory ProductModel.create({
    required String name,
    required int productTypeId,
    List<LotModel>? lots,
  }) {
    return ProductModel(
      id: 0,
      name: name,
      productTypeId: productTypeId,
      productType: null,
      lots: lots,
    );
  }

  factory ProductModel.fromDrift(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      productTypeId: product.productTypeId,
    );
  }

  factory ProductModel.fromJson(Map<String, Object?> json) {
    final lots = json['lots'];

    return ProductModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      productTypeId: (json['productTypeId'] as num).toInt(),
      productType: json['productType'] is Map<String, Object?>
          ? ProductTypeModel.fromJson(
              json['productType'] as Map<String, Object?>,
            )
          : null,
      lots: lots is List
          ? lots
                .whereType<Map>()
                .map(
                  (item) => LotModel.fromJson(Map<String, Object?>.from(item)),
                )
                .toList()
          : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'productTypeId': productTypeId,
      if (productType != null) 'productType': productType!.toJson(),
      if (lots != null) 'lots': lots!.map((lot) => lot.toJson()).toList(),
    };
  }

  ProductsCompanion toCompanion({bool insertingNew = false}) {
    return ProductsCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
      productTypeId: Value(productTypeId),
    );
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? productTypeId,
    ProductTypeModel? productType,
    List<LotModel>? lots,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      productTypeId: productTypeId ?? this.productTypeId,
      productType: productType ?? this.productType,
      lots: lots ?? this.lots,
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
          productType == other.productType &&
          lots == other.lots;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      productTypeId.hashCode ^
      (productType?.hashCode ?? 0) ^
      (lots?.hashCode ?? 0);

  @override
  String toString() =>
      'ProductModel(id: $id, name: $name, productTypeId: $productTypeId, productType: $productType, lots: $lots)';
}
