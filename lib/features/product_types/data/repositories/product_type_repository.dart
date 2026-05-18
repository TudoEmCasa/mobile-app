import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';

class ProductTypeRepository {
  final AppDatabase _db;

  ProductTypeRepository(this._db);

  Future<int> createProductType(String name, int categoryId) {
    final companion = ProductTypesCompanion.insert(
      name: name,
      categoryId: categoryId,
    );

    return _db.into(_db.productTypes).insert(companion);
  }

  Future<ProductTypeModel?> getProductTypeById(int id) async {
    final query = _db.select(_db.productTypes).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.productTypes.categoryId),
      ),
    ])..where(_db.productTypes.id.equals(id));

    final row = await query.getSingleOrNull();

    if (row == null) {
      return null;
    }

    final productType = row.readTable(_db.productTypes);
    final category = row.readTable(_db.categories);

    return ProductTypeModel(
      id: productType.id,
      name: productType.name,
      categoryId: productType.categoryId,
      category: CategoryModel.fromDrift(category),
    );
  }

  Future<List<ProductTypeModel>> getProductTypes() async {
    final query = (_db.select(_db.productTypes)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc),
      ]));
    final productTypes = await query.get();

    return productTypes.map((productType) {
      return ProductTypeModel.fromDrift(productType);
    }).toList();
  }

  Future<void> clearProductTypes() async {
    await _db.delete(_db.productTypes).go();
  }

  Future<void> insertProductTypes(List<ProductTypeModel> productTypes) async {
    if (productTypes.isEmpty) {
      return;
    }

    final companions = productTypes.map((productType) {
      return productType.toCompanion();
    }).toList();

    await _db.batch((batch) {
      batch.insertAll(_db.productTypes, companions);
    });
  }

  Stream<ProductTypeModel?> watchProductTypeById(int id) {
    final query = _db.select(_db.productTypes)..where((t) => t.id.equals(id));

    return query.watch().asyncMap((productTypes) async {
      if (productTypes.isEmpty) {
        return null;
      }

      final productType = productTypes.first;
      final categoryQuery = _db.select(_db.categories)
        ..where((t) => t.id.equals(productType.categoryId));
      final category = await categoryQuery.getSingleOrNull();

      if (category == null) {
        return null;
      }

      return ProductTypeModel(
        id: productType.id,
        name: productType.name,
        categoryId: productType.categoryId,
        category: CategoryModel.fromDrift(category),
      );
    });
  }

  Stream<List<ProductTypeModel>> watchProductTypes() {
    final query =
        _db.select(_db.productTypes).join([
          innerJoin(
            _db.categories,
            _db.categories.id.equalsExp(_db.productTypes.categoryId),
          ),
        ])..orderBy([
          OrderingTerm(
            expression: _db.productTypes.name,
            mode: OrderingMode.asc,
          ),
        ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final productType = row.readTable(_db.productTypes);
        final category = row.readTable(_db.categories);

        return ProductTypeModel(
          id: productType.id,
          name: productType.name,
          categoryId: productType.categoryId,
          category: CategoryModel.fromDrift(category),
        );
      }).toList();
    });
  }

  Future<bool> updateProductType(ProductTypeModel productType) async {
    final companion = ProductTypesCompanion(
      id: Value(productType.id),
      name: Value(productType.name),
      categoryId: Value(productType.categoryId),
    );

    return _db.update(_db.productTypes).replace(companion);
  }

  Future<bool> deleteProductType(int id) async {
    await (_db.delete(_db.productTypes)..where((t) => t.id.equals(id))).go();

    return true;
  }
}
