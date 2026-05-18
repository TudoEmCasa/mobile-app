import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';

class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  Future<int> createProduct({
    required String name,
    required int productTypeId,
    required int unitId,
    required double quantity,
    DateTime? expirationDate,
  }) {
    final normalizedExpiration = expirationDate != null
        ? DateTime(
            expirationDate.year,
            expirationDate.month,
            expirationDate.day,
          )
        : null;

    final companion = ProductsCompanion.insert(
      name: name,
      productTypeId: productTypeId,
      unitId: unitId,
      quantity: quantity,
      expirationDate: Value(normalizedExpiration),
      createdAt: DateTime.now(),
    );

    return _db.into(_db.products).insert(companion);
  }

  Future<ProductModel?> getProductById(int id) async {
    final query = _db.select(_db.products).join([
      innerJoin(
        _db.productTypes,
        _db.productTypes.id.equalsExp(_db.products.productTypeId),
      ),
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.productTypes.categoryId),
      ),
      innerJoin(_db.units, _db.units.id.equalsExp(_db.products.unitId)),
    ])..where(_db.products.id.equals(id));

    final row = await query.getSingleOrNull();

    if (row == null) return null;

    final product = row.readTable(_db.products);
    final productType = row.readTable(_db.productTypes);
    final category = row.readTable(_db.categories);
    final unit = row.readTable(_db.units);

    return ProductModel(
      id: product.id,
      name: product.name,
      productTypeId: product.productTypeId,
      unitId: product.unitId,
      quantity: product.quantity,
      expirationDate: product.expirationDate,
      createdAt: product.createdAt,
      productType: ProductTypeModel(
        id: productType.id,
        name: productType.name,
        categoryId: productType.categoryId,
        category: CategoryModel.fromDrift(category),
      ),
      unit: UnitModel.fromDrift(unit),
    );
  }

  Future<List<ProductModel>> getProducts() async {
    final query = (_db.select(_db.products)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));
    final products = await query.get();

    return products.map(ProductModel.fromDrift).toList();
  }

  Stream<ProductModel?> watchProductById(int id) {
    final query = _db.select(_db.products)..where((t) => t.id.equals(id));

    return query.watch().asyncMap((products) async {
      if (products.isEmpty) return null;

      final product = products.first;

      final productTypeRow = await (_db.select(
        _db.productTypes,
      )..where((t) => t.id.equals(product.productTypeId))).getSingleOrNull();
      final categoryRow = productTypeRow != null
          ? await (_db.select(_db.categories)
                  ..where((t) => t.id.equals(productTypeRow.categoryId)))
                .getSingleOrNull()
          : null;
      final unitRow = await (_db.select(
        _db.units,
      )..where((t) => t.id.equals(product.unitId))).getSingleOrNull();

      return ProductModel(
        id: product.id,
        name: product.name,
        productTypeId: product.productTypeId,
        unitId: product.unitId,
        quantity: product.quantity,
        expirationDate: product.expirationDate,
        createdAt: product.createdAt,
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
        unit: unitRow != null ? UnitModel.fromDrift(unitRow) : null,
      );
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
          leftOuterJoin(_db.units, _db.units.id.equalsExp(_db.products.unitId)),
        ])..orderBy([
          OrderingTerm(expression: _db.products.name, mode: OrderingMode.asc),
        ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final product = row.readTable(_db.products);
        final productType = row.readTableOrNull(_db.productTypes);
        final category = row.readTableOrNull(_db.categories);
        final unit = row.readTableOrNull(_db.units);

        return ProductModel(
          id: product.id,
          name: product.name,
          productTypeId: product.productTypeId,
          unitId: product.unitId,
          quantity: product.quantity,
          expirationDate: product.expirationDate,
          createdAt: product.createdAt,
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
          unit: unit != null ? UnitModel.fromDrift(unit) : null,
        );
      }).toList();
    });
  }

  Future<bool> updateProduct(ProductModel product) async {
    final companion = product.toCompanion();

    return _db.update(_db.products).replace(companion);
  }

  Future<bool> deleteProduct(int id) async {
    await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();

    return true;
  }
}
