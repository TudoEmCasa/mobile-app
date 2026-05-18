import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';

class UnitModel {
  final int id;
  final String name;
  final String symbol;

  UnitModel({required this.id, required this.name, required this.symbol});

  factory UnitModel.create({required String name, required String symbol}) {
    return UnitModel(id: 0, name: name, symbol: symbol);
  }

  factory UnitModel.fromDrift(Unit unit) {
    return UnitModel(id: unit.id, name: unit.name, symbol: unit.symbol);
  }

  factory UnitModel.fromJson(Map<String, Object?> json) {
    return UnitModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  Map<String, Object?> toJson() {
    return {'id': id, 'name': name, 'symbol': symbol};
  }

  UnitsCompanion toCompanion({bool insertingNew = false}) {
    return UnitsCompanion(
      id: insertingNew ? const Value.absent() : Value(id),
      name: Value(name),
      symbol: Value(symbol),
    );
  }

  UnitModel copyWith({int? id, String? name, String? symbol}) {
    return UnitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          symbol == other.symbol;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ symbol.hashCode;

  @override
  String toString() => 'UnitModel(id: $id, name: $name, symbol: $symbol)';
}
