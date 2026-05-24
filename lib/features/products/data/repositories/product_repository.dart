import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/lots/data/repositories/lot_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';
import 'package:tudo_em_casa/features/products/data/exceptions/product_quantity_consumption_exception.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';

class ProductRepository {
  final AppDatabase _db;
  final LotRepository _lotRepository;

  ProductRepository(this._db, this._lotRepository);

  Future<int> createProduct(ProductModel product) async {
    final productId = await _db
        .into(_db.products)
        .insert(product.toCompanion(insertingNew: true));

    final lots = product.lots;
    if (lots != null && lots.isNotEmpty) {
      await _lotRepository.insertLots(
        lots.map((lot) => lot.copyWith(productId: productId)).toList(),
      );
    }

    return productId;
  }

  Future<ProductModel?> getProductById(int id) async {
    final product = await (_db.select(
      _db.products,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (product == null) {
      return null;
    }

    return _loadProductRelations(ProductModel.fromDrift(product));
  }

  Future<List<ProductModel>> getProducts() async {
    final products =
        await (_db.select(_db.products)..orderBy([
              (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
            ]))
            .get();

    return Future.wait(
      products.map(
        (product) => _loadProductRelations(ProductModel.fromDrift(product)),
      ),
    );
  }

  Future<void> clearProducts() async {
    await _db.delete(_db.products).go();
  }

  Future<void> insertProducts(List<ProductModel> products) async {
    if (products.isEmpty) {
      return;
    }

    await _db.batch((batch) {
      batch.insertAll(
        _db.products,
        products.map((product) => product.toCompanion()).toList(),
      );
    });

    final lots = <LotModel>[];
    for (final product in products) {
      final productLots = product.lots;

      if (productLots == null || productLots.isEmpty) {
        continue;
      }

      lots.addAll(
        productLots.map((lot) => lot.copyWith(productId: product.id)),
      );
    }

    if (lots.isNotEmpty) {
      await _lotRepository.insertLots(lots);
    }
  }

  Stream<ProductModel?> watchProductById(int id) {
    final query = _db.select(_db.products)..where((t) => t.id.equals(id));

    return query.watchSingleOrNull().asyncMap((product) async {
      if (product == null) {
        return null;
      }

      return _loadProductRelations(ProductModel.fromDrift(product));
    });
  }

  Stream<List<ProductModel>> watchProducts() {
    final query =
        _db.select(_db.products).join([
          leftOuterJoin(
            _db.productTypes,
            _db.productTypes.id.equalsExp(_db.products.productTypeId),
          ),
          leftOuterJoin(
            _db.categories,
            _db.categories.id.equalsExp(_db.productTypes.categoryId),
          ),
        ])..orderBy([
          OrderingTerm(expression: _db.products.name, mode: OrderingMode.asc),
        ]);

    return query.watch().asyncMap((rows) async {
      final products = rows.map((row) {
        final product = row.readTable(_db.products);
        final productType = row.readTableOrNull(_db.productTypes);
        final category = row.readTableOrNull(_db.categories);

        return ProductModel(
          id: product.id,
          name: product.name,
          productTypeId: product.productTypeId,
          productType: productType != null
              ? ProductTypeModel(
                  id: productType.id,
                  name: productType.name,
                  categoryId: productType.categoryId,
                  category: category != null
                      ? CategoryModel.fromDrift(category)
                      : null,
                )
              : null,
        );
      }).toList();

      return Future.wait(products.map(_loadProductRelations));
    });
  }

  Future<bool> updateProduct(ProductModel product) async {
    await _db.update(_db.products).replace(product.toCompanion());

    final lots = product.lots;
    if (lots != null && lots.isNotEmpty) {
      final firstLot = lots.first;
      if (firstLot.id == 0) {
        await _lotRepository.createLot(
          firstLot.copyWith(productId: product.id),
        );
      } else {
        await _lotRepository.updateLot(
          firstLot.copyWith(productId: product.id),
        );
      }
    }

    return true;
  }

  Future<ProductModel> consumeProductQuantity({
    required int productId,
    required double quantity,
  }) async {
    if (!quantity.isFinite || quantity <= 0) {
      throw const ProductQuantityConsumptionException(
        'Quantity must be greater than zero',
      );
    }

    return _db.transaction(() async {
      final currentProduct = await getProductById(productId);

      if (currentProduct == null) {
        throw const ProductQuantityConsumptionException('Product not found');
      }

      final currentLots = currentProduct.lots ?? const <LotModel>[];
      if (currentLots.isEmpty) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      final currentLot = currentLots.first;

      if (quantity > currentLot.quantity) {
        throw const ProductQuantityConsumptionException(
          'Insufficient quantity',
        );
      }

      await _lotRepository.updateLot(
        currentLot.copyWith(quantity: currentLot.quantity - quantity),
      );

      final updatedProduct = await getProductById(productId);

      if (updatedProduct == null) {
        throw const ProductQuantityConsumptionException('Product not found');
      }

      return updatedProduct;
    });
  }

  Future<ProductModel> addProductQuantity({
    required int productId,
    required double quantity,
  }) async {
    if (!quantity.isFinite || quantity <= 0) {
      throw const ProductQuantityConsumptionException(
        'Quantity must be greater than zero',
      );
    }

    return _db.transaction(() async {
      final currentProduct = await getProductById(productId);

      if (currentProduct == null) {
        throw const ProductQuantityConsumptionException('Product not found');
      }

      final currentLots = currentProduct.lots ?? const <LotModel>[];
      if (currentLots.isEmpty) {
        throw const ProductQuantityConsumptionException('Lot not found');
      }

      final currentLot = currentLots.first;
      await _lotRepository.updateLot(
        currentLot.copyWith(quantity: currentLot.quantity + quantity),
      );

      final updatedProduct = await getProductById(productId);

      if (updatedProduct == null) {
        throw const ProductQuantityConsumptionException('Product not found');
      }

      return updatedProduct;
    });
  }

  Future<bool> deleteProduct(int id) async {
    await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();

    return true;
  }

  Future<ProductModel> _loadProductRelations(ProductModel product) async {
    final productTypeRow = await (_db.select(
      _db.productTypes,
    )..where((t) => t.id.equals(product.productTypeId))).getSingleOrNull();
    final categoryRow = productTypeRow != null
        ? await (_db.select(_db.categories)
                ..where((t) => t.id.equals(productTypeRow.categoryId)))
              .getSingleOrNull()
        : null;
    final lots = await _lotRepository.getLotsByProductId(product.id);

    return product.copyWith(
      productType: productTypeRow != null
          ? ProductTypeModel(
              id: productTypeRow.id,
              name: productTypeRow.name,
              categoryId: productTypeRow.categoryId,
              category: categoryRow != null
                  ? CategoryModel.fromDrift(categoryRow)
                  : null,
            )
          : null,
      lots: lots.isEmpty ? null : lots,
    );
  }
}
