import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';
import 'package:tudo_em_casa/features/units/data/repositories/unit_repository.dart';

void main() {
  late AppDatabase db;
  late CategoryRepository categoryRepository;
  late ProductTypeRepository productTypeRepository;
  late UnitRepository unitRepository;
  late ProductRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    categoryRepository = CategoryRepository(db);
    productTypeRepository = ProductTypeRepository(db);
    unitRepository = UnitRepository(db);
    repository = ProductRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'createProduct persists and returns id with relational mapping',
    () async {
      final categoryId = await categoryRepository.createCategory('Fruits');
      final productTypeId = await productTypeRepository.createProductType(
        'Apple',
        categoryId,
      );
      final unitId = await unitRepository.createUnit('Kilogram', 'kg');

      final id = await repository.createProduct(
        name: 'Green Apple',
        productTypeId: productTypeId,
        unitId: unitId,
        quantity: 1.5,
        expirationDate: DateTime(2026, 12, 31),
      );

      expect(id, greaterThan(0));

      final product = await repository.getProductById(id);
      expect(product, isNotNull);
      expect(product!.name, 'Green Apple');
      expect(product.productType, isNotNull);
      expect(product.productType!.name, 'Apple');
      expect(product.productType!.category, isNotNull);
      expect(product.productType!.category!.name, 'Fruits');
      expect(product.unit, isNotNull);
      expect(product.unit!.symbol, 'kg');
    },
  );

  test('watchProducts emits initial empty and then items', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Unit', 'u');

    final stream = repository.watchProducts();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<List<ProductModel>>((list) => list.isEmpty),
        predicate<List<ProductModel>>((list) => list.length == 2),
      ]),
    );

    await repository.createProduct(
      name: 'A',
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: 1.0,
    );
    await repository.createProduct(
      name: 'B',
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: 2.0,
    );

    await expectation;
  });

  test('updateProduct persists changes', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Unit', 'u');
    final id = await repository.createProduct(
      name: 'A',
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: 1.0,
    );

    final fetched = await repository.getProductById(id);
    expect(fetched, isNotNull);

    final updated = fetched!.copyWith(name: 'Updated A', quantity: 5.0);
    final result = await repository.updateProduct(updated);
    expect(result, isTrue);

    final fromDb = await repository.getProductById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.name, 'Updated A');
    expect(fromDb.quantity, 5.0);
  });

  test('deleteProduct removes product and updates watchers', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Unit', 'u');

    final firstId = await repository.createProduct(
      name: 'A',
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: 1.0,
    );
    final secondId = await repository.createProduct(
      name: 'B',
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: 2.0,
    );

    final stream = repository.watchProducts();

    final expectation = expectLater(
      stream,
      emitsInOrder([
        predicate<List<ProductModel>>((list) {
          final ids = list.map((item) => item.id).toList();
          return ids.contains(firstId) && ids.contains(secondId);
        }),
        predicate<List<ProductModel>>(
          (list) => list.every((i) => i.id != firstId),
        ),
      ]),
    );

    await repository.deleteProduct(firstId);

    await expectation;

    final deleted = await repository.getProductById(firstId);
    expect(deleted, isNull);
  });
}
