import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';

class ProductTypeModel {
  final int id;
  final String name;
  final int categoryId;

  ProductTypeModel({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory ProductTypeModel.create({
    required String name,
    required int categoryId,
  }) {
    return ProductTypeModel(id: 0, name: name, categoryId: categoryId);
  }

  factory ProductTypeModel.fromDrift(ProductType productType) {
    return ProductTypeModel(
      id: productType.id,
      name: productType.name,
      categoryId: productType.categoryId,
    );
  }

  ProductTypesCompanion toCompanion({bool insertingNew = false}) {
    return ProductTypesCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
    );
  }

  ProductTypeModel copyWith({int? id, String? name, int? categoryId}) {
    return ProductTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          categoryId == other.categoryId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ categoryId.hashCode;

  @override
  String toString() =>
      'ProductTypeModel(id: $id, name: $name, categoryId: $categoryId)';
}
