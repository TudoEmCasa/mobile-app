class ProductTypeWithCategoryModel {
  final int id;
  final String name;
  final int categoryId;
  final String categoryName;

  ProductTypeWithCategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
  });

  ProductTypeWithCategoryModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? categoryName,
  }) {
    return ProductTypeWithCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeWithCategoryModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          categoryId == other.categoryId &&
          categoryName == other.categoryName;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ categoryId.hashCode ^ categoryName.hashCode;

  @override
  String toString() {
    return 'ProductTypeWithCategoryModel(id: $id, name: $name, categoryId: $categoryId, categoryName: $categoryName)';
  }
}
