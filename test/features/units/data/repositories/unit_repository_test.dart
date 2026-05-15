import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';
import 'package:tudo_em_casa/features/units/data/repositories/unit_repository.dart';

void main() {
  late AppDatabase db;
  late UnitRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = UnitRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createUnit persists and can be retrieved by id', () async {
    final id = await repo.createUnit('Kilogram', 'kg');

    expect(id, greaterThan(0));

    final unit = await repo.getUnitById(id);
    expect(unit, isNotNull);
    expect(unit!.name, 'Kilogram');
    expect(unit.symbol, 'kg');
  });

  test('getUnitById returns null for non existing id', () async {
    final unit = await repo.getUnitById(9999);
    expect(unit, isNull);
  });

  test(
    'watchUnitById emits updates when unit changes and null after delete',
    () async {
      final id = await repo.createUnit('Liter', 'L');

      final stream = repo.watchUnitById(id);
      final emitted = <UnitModel?>[];
      final sub = stream.listen(emitted.add);

      await Future<void>.delayed(Duration.zero);

      await repo.updateUnit(
        UnitModel(id: id, name: 'Milliliter', symbol: 'mL'),
      );
      await Future<void>.delayed(Duration.zero);

      await repo.deleteUnit(id);
      await Future<void>.delayed(Duration.zero);

      await sub.cancel();

      expect(emitted.length, 3);
      expect(
        emitted[0],
        predicate<UnitModel?>((u) => u != null && u.name == 'Liter'),
      );
      expect(
        emitted[1],
        predicate<UnitModel?>((u) => u != null && u.name == 'Milliliter'),
      );
      expect(emitted[2], isNull);
    },
  );

  test('watchUnits returns ordered list and reacts to inserts', () async {
    final stream = repo.watchUnits();

    final expectation = expectLater(
      stream,
      emitsThrough(
        predicate<List<UnitModel>>((list) {
          final names = list.map((e) => e.name).toList();
          return names.join(',') == 'Kilogram,Liter';
        }),
      ),
    );

    await repo.createUnit('Liter', 'L');
    await repo.createUnit('Kilogram', 'kg');

    await expectation;
  });

  test('updateUnit persists changes', () async {
    final id = await repo.createUnit('Unit', 'un');

    final updated = UnitModel(id: id, name: 'Piece', symbol: 'pc');
    final result = await repo.updateUnit(updated);

    expect(result, isTrue);

    final fromDb = await repo.getUnitById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.name, 'Piece');
    expect(fromDb.symbol, 'pc');
  });

  test('deleteUnit removes the unit and updates watchers', () async {
    final firstId = await repo.createUnit('One', '1');
    final secondId = await repo.createUnit('Two', '2');

    final stream = repo.watchUnits();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<List<UnitModel>>(
          (list) =>
              list.map((u) => u.id).contains(firstId) &&
              list.map((u) => u.id).contains(secondId),
        ),
        predicate<List<UnitModel>>(
          (list) => list.every((u) => u.id != firstId),
        ),
      ]),
    );

    await repo.deleteUnit(firstId);

    await expectation;

    final deleted = await repo.getUnitById(firstId);
    expect(deleted, isNull);
  });
}
