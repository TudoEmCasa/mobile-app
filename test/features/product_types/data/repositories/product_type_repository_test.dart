import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';

void main() {
  late AppDatabase db;
  late CategoryRepository categoryRepository;
  late ProductTypeRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    categoryRepository = CategoryRepository(db);
    repository = ProductTypeRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('createProductType persists and returns the inserted id', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');

    final id = await repository.createProductType('Apple', categoryId);

    expect(id, greaterThan(0));

    final productType = await repository.getProductTypeById(id);
    expect(productType, isNotNull);
    expect(productType!.name, 'Apple');
    expect(productType.categoryId, categoryId);
    expect(productType.category, isNotNull);
    expect(productType.category!.name, 'Fruits');
  });

  test('getProductTypeById returns null for non existing id', () async {
    final productType = await repository.getProductTypeById(9999);

    expect(productType, isNull);
  });

  test('watchProductTypeById emits updates and null after deletion', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final id = await repository.createProductType('Apple', categoryId);

    final stream = repository.watchProductTypeById(id);
    final emittedValues = <ProductTypeModel?>[];
    final subscription = stream.listen(emittedValues.add);

    await Future<void>.delayed(Duration.zero);

    await repository.updateProductType(
      ProductTypeModel(id: id, name: 'Green Apple', categoryId: categoryId),
    );
    await Future<void>.delayed(Duration.zero);

    await repository.deleteProductType(id);
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();

    expect(emittedValues.length, 3);
    expect(
      emittedValues[0],
      predicate<ProductTypeModel?>((productType) {
        return productType != null && productType.name == 'Apple';
      }),
    );
    expect(
      emittedValues[1],
      predicate<ProductTypeModel?>((productType) {
        return productType != null && productType.name == 'Green Apple';
      }),
    );
    expect(emittedValues[2], isNull);
  });

  test(
    'watchProductTypes emits empty list initially and inserted items',
    () async {
      final categoryId = await categoryRepository.createCategory('Fruits');

      final stream = repository.watchProductTypes();

      final expectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<ProductTypeModel>>((list) => list.isEmpty),
          predicate<List<ProductTypeModel>>((list) {
            final names = list.map((item) => item.name).toList();

            return names.join(',') == 'Apple,Banana';
          }),
        ]),
      );

      await repository.createProductType('Apple', categoryId);
      await repository.createProductType('Banana', categoryId);

      await expectation;
    },
  );

  test('watchProductTypes emits updated list after updates', () async {
    final fruitsCategoryId = await categoryRepository.createCategory('Fruits');
    final vegetablesCategoryId = await categoryRepository.createCategory(
      'Vegetables',
    );

    final appleId = await repository.createProductType(
      'Apple',
      fruitsCategoryId,
    );
    final bananaId = await repository.createProductType(
      'Banana',
      fruitsCategoryId,
    );

    final stream = repository.watchProductTypes();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<List<ProductTypeModel>>((list) {
          final names = list.map((item) => item.name).toList();

          return names.join(',') == 'Apple,Banana';
        }),
        predicate<List<ProductTypeModel>>((list) {
          final names = list.map((item) => item.name).toList();
          final categories = list.map((item) => item.category?.name).toList();

          return names.join(',') == 'Apple,Apricot' &&
              categories.join(',') == 'Fruits,Vegetables';
        }),
      ]),
    );

    await repository.updateProductType(
      ProductTypeModel(
        id: bananaId,
        name: 'Apricot',
        categoryId: vegetablesCategoryId,
      ),
    );

    await expectation;

    final firstProductType = await repository.getProductTypeById(appleId);
    expect(firstProductType, isNotNull);
    expect(firstProductType!.name, 'Apple');
  });

  test('updateProductType persists changes', () async {
    final fruitsCategoryId = await categoryRepository.createCategory('Fruits');
    final vegetablesCategoryId = await categoryRepository.createCategory(
      'Vegetables',
    );
    final id = await repository.createProductType('Apple', fruitsCategoryId);

    final updated = ProductTypeModel(
      id: id,
      name: 'Pear',
      categoryId: vegetablesCategoryId,
    );
    final result = await repository.updateProductType(updated);

    expect(result, isTrue);

    final fromDb = await repository.getProductTypeById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.name, 'Pear');
    expect(fromDb.categoryId, vegetablesCategoryId);
    expect(fromDb.category, isNotNull);
    expect(fromDb.category!.name, 'Vegetables');
  });

  test(
    'deleteProductType removes the product type and updates watchers',
    () async {
      final categoryId = await categoryRepository.createCategory('Fruits');
      final firstId = await repository.createProductType('Apple', categoryId);
      final secondId = await repository.createProductType('Banana', categoryId);

      final stream = repository.watchProductTypes();

      final expectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<ProductTypeModel>>((list) {
            final ids = list.map((item) => item.id).toList();

            return ids.contains(firstId) && ids.contains(secondId);
          }),
          predicate<List<ProductTypeModel>>(
            (list) => list.every((item) => item.id != firstId),
          ),
        ]),
      );

      await repository.deleteProductType(firstId);

      await expectation;

      final deleted = await repository.getProductTypeById(firstId);
      expect(deleted, isNull);
    },
  );
}
