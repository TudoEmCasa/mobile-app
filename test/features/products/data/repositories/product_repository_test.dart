import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/lots/data/models/lot_model.dart';
import 'package:tudo_em_casa/features/lots/data/repositories/lot_repository.dart';
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
    repository = ProductRepository(db, LotRepository(db));
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
        ProductModel(
          id: 0,
          name: 'Green Apple',
          productTypeId: productTypeId,
          lots: [
            LotModel(
              id: 0,
              productId: 0,
              unitId: unitId,
              quantity: 1.5,
              expirationDate: DateTime(2026, 12, 31),
            ),
          ],
        ),
      );

      expect(id, greaterThan(0));

      final product = await repository.getProductById(id);
      expect(product, isNotNull);
      expect(product!.name, 'Green Apple');
      expect(product.productType, isNotNull);
      expect(product.productType!.name, 'Apple');
      expect(product.productType!.category, isNotNull);
      expect(product.productType!.category!.name, 'Fruits');
      expect(product.lots, hasLength(1));
      expect(product.lots!.single.unit, isNotNull);
      expect(product.lots!.single.unit!.symbol, 'kg');
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
      ProductModel(
        id: 0,
        name: 'A',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 1.0,
            expirationDate: null,
          ),
        ],
      ),
    );
    await repository.createProduct(
      ProductModel(
        id: 0,
        name: 'B',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 2.0,
            expirationDate: null,
          ),
        ],
      ),
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
      ProductModel(
        id: 0,
        name: 'A',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 1.0,
            expirationDate: null,
          ),
        ],
      ),
    );

    final fetched = await repository.getProductById(id);
    expect(fetched, isNotNull);

    final updated = fetched!.copyWith(
      name: 'Updated A',
      lots: [fetched.lots!.first.copyWith(quantity: 5.0)],
    );
    final result = await repository.updateProduct(updated);
    expect(result, isTrue);

    final fromDb = await repository.getProductById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.name, 'Updated A');
    expect(fromDb.lots!.first.quantity, 5.0);
  });

  test(
    'consumeProductQuantity subtracts quantity and keeps product visible',
    () async {
      final categoryId = await categoryRepository.createCategory('Fruits');
      final productTypeId = await productTypeRepository.createProductType(
        'Apple',
        categoryId,
      );
      final unitId = await unitRepository.createUnit('Package', 'pkg');
      final id = await repository.createProduct(
        ProductModel(
          id: 0,
          name: 'Rice',
          productTypeId: productTypeId,
          lots: [
            LotModel(
              id: 0,
              productId: 0,
              unitId: unitId,
              quantity: 5.0,
              expirationDate: null,
            ),
          ],
        ),
      );

      final updated = await repository.consumeProductQuantity(
        productId: id,
        quantity: 2.0,
      );

      expect(updated.lots!.first.quantity, 3.0);

      final fromDb = await repository.getProductById(id);
      expect(fromDb, isNotNull);
      expect(fromDb!.lots!.first.quantity, 3.0);

      final consumedAll = await repository.consumeProductQuantity(
        productId: id,
        quantity: 3.0,
      );

      expect(consumedAll.lots!.first.quantity, 0.0);

      final zeroQuantityProduct = await repository.getProductById(id);
      expect(zeroQuantityProduct, isNotNull);
      expect(zeroQuantityProduct!.lots!.first.quantity, 0.0);
    },
  );

  test('addProductQuantity adds quantity and persists change', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Package', 'pkg');
    final id = await repository.createProduct(
      ProductModel(
        id: 0,
        name: 'Rice',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 5.0,
            expirationDate: null,
          ),
        ],
      ),
    );

    final updated = await repository.addProductQuantity(
      productId: id,
      quantity: 2.5,
    );

    expect(updated.lots!.first.quantity, 7.5);

    final fromDb = await repository.getProductById(id);
    expect(fromDb, isNotNull);
    expect(fromDb!.lots!.first.quantity, 7.5);
  });

  test(
    'consumeProductQuantity rejects invalid or excessive quantity',
    () async {
      final categoryId = await categoryRepository.createCategory('Fruits');
      final productTypeId = await productTypeRepository.createProductType(
        'Apple',
        categoryId,
      );
      final unitId = await unitRepository.createUnit('Package', 'pkg');
      final id = await repository.createProduct(
        ProductModel(
          id: 0,
          name: 'Rice',
          productTypeId: productTypeId,
          lots: [
            LotModel(
              id: 0,
              productId: 0,
              unitId: unitId,
              quantity: 5.0,
              expirationDate: null,
            ),
          ],
        ),
      );

      expect(
        () => repository.consumeProductQuantity(productId: id, quantity: 0),
        throwsA(isA<Exception>()),
      );

      expect(
        () => repository.consumeProductQuantity(productId: id, quantity: 6),
        throwsA(isA<Exception>()),
      );
    },
  );

  test('addProductQuantity rejects invalid quantity', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Package', 'pkg');
    final id = await repository.createProduct(
      ProductModel(
        id: 0,
        name: 'Rice',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 5.0,
            expirationDate: null,
          ),
        ],
      ),
    );

    expect(
      () => repository.addProductQuantity(productId: id, quantity: 0),
      throwsA(isA<Exception>()),
    );
  });

  test('deleteProduct removes product and updates watchers', () async {
    final categoryId = await categoryRepository.createCategory('Fruits');
    final productTypeId = await productTypeRepository.createProductType(
      'Apple',
      categoryId,
    );
    final unitId = await unitRepository.createUnit('Unit', 'u');

    final firstId = await repository.createProduct(
      ProductModel(
        id: 0,
        name: 'A',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 1.0,
            expirationDate: null,
          ),
        ],
      ),
    );
    final secondId = await repository.createProduct(
      ProductModel(
        id: 0,
        name: 'B',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 2.0,
            expirationDate: null,
          ),
        ],
      ),
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
