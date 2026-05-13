class CategoryModel {
  final int id;

  final String name;

  CategoryModel({required this.id, required this.name});

  factory CategoryModel.create({required String name}) {
    return CategoryModel(id: 0, name: name);
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
