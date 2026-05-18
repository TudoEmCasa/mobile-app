import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';

class ProductTypeModel {
  final int id;
  final String name;
  final int categoryId;
  final CategoryModel? category;

  ProductTypeModel({
    required this.id,
    required this.name,
    required this.categoryId,
    this.category,
  });

  factory ProductTypeModel.create({
    required String name,
    required int categoryId,
  }) {
    return ProductTypeModel(
      id: 0,
      name: name,
      categoryId: categoryId,
      category: null,
    );
  }

  factory ProductTypeModel.fromDrift(ProductType productType) {
    return ProductTypeModel(
      id: productType.id,
      name: productType.name,
      categoryId: productType.categoryId,
    );
  }

  factory ProductTypeModel.fromJson(Map<String, Object?> json) {
    return ProductTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      category: json['category'] is Map<String, Object?>
          ? CategoryModel.fromJson(json['category'] as Map<String, Object?>)
          : null,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      if (category != null) 'category': category!.toJson(),
    };
  }

  ProductTypesCompanion toCompanion({bool insertingNew = false}) {
    return ProductTypesCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
      categoryId: Value(categoryId),
    );
  }

  ProductTypeModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    CategoryModel? category,
  }) {
    return ProductTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          categoryId == other.categoryId &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      categoryId.hashCode ^
      (category?.hashCode ?? 0);

  @override
  String toString() =>
      'ProductTypeModel(id: $id, name: $name, categoryId: $categoryId, category: $category)';
}
