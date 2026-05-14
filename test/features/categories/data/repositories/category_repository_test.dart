import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';

void main() {
  late AppDatabase db;
  late CategoryRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = CategoryRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createCategory persists and can be retrieved by id', () async {
    final id = await repo.createCategory('Fruits');

    expect(id, greaterThan(0));

    final category = await repo.getCategoryById(id);
    expect(category, isNotNull);
    expect(category!.name, 'Fruits');
  });

  test('getCategoryById returns null for non existing id', () async {
    final category = await repo.getCategoryById(9999);
    expect(category, isNull);
  });

  test('watchCategoryById emits updates when category changes', () async {
    final id = await repo.createCategory('A');

    final stream = repo.watchCategoryById(id);

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<CategoryModel?>((c) => c != null && c.name == 'A'),
        predicate<CategoryModel?>((c) => c != null && c.name == 'B'),
      ]),
    );

    // perform update that should trigger the second emission
    await repo.updateCategory(CategoryModel(id: id, name: 'B'));

    await expectation;
  });

  test(
    'watchCategories returns alphabetically ordered list and reacts to inserts',
    () async {
      await repo.createCategory('Banana');
      await repo.createCategory('Apple');
      await repo.createCategory('Orange');

      final stream = repo.watchCategories();

      final expectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<CategoryModel>>((list) {
            final names = list.map((e) => e.name).toList();
            return names.join(',') == 'Apple,Banana,Orange';
          }),
          predicate<List<CategoryModel>>((list) {
            final names = list.map((e) => e.name).toList();
            return names.join(',') == 'Apple,Apricot,Banana,Orange';
          }),
        ]),
      );

      // Insert a new category that should appear in alphabetical order
      await repo.createCategory('Apricot');

      await expectation;
    },
  );

  test('updateCategory persists changes', () async {
    final id = await repo.createCategory('Vegetables');

    final updated = CategoryModel(id: id, name: 'Greens');
    final result = await repo.updateCategory(updated);

    expect(result, isTrue);

    final fromDb = await repo.getCategoryById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.name, 'Greens');
  });

  test('deleteCategory removes the category and updates watchers', () async {
    final id1 = await repo.createCategory('One');
    final id2 = await repo.createCategory('Two');

    final stream = repo.watchCategories();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<List<CategoryModel>>(
          (list) =>
              list.map((c) => c.id).contains(id1) &&
              list.map((c) => c.id).contains(id2),
        ),
        predicate<List<CategoryModel>>(
          (list) => list.every((c) => c.id != id1),
        ),
      ]),
    );

    await repo.deleteCategory(id1);

    await expectation;

    final deleted = await repo.getCategoryById(id1);
    expect(deleted, isNull);
  });
}
