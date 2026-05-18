import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';

class CategoryModel {
  final int id;

  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.create({required String name}) {
    return CategoryModel(id: 0, name: name);
  }

  factory CategoryModel.fromDrift(Category category) {
    return CategoryModel(id: category.id, name: category.name);
  }

  factory CategoryModel.fromJson(Map<String, Object?> json) {
    return CategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name};
  }

  CategoriesCompanion toCompanion({bool insertingNew = false}) {
    return CategoriesCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
    );
  }

  CategoryModel copyWith({int? id, String? name}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
