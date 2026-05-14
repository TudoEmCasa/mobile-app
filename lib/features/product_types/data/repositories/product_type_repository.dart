import 'package:drift/drift.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
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

  Stream<List<ProductTypeWithCategoryModel>> watchProductTypes() {
    final query = _db.select(_db.productTypes).join([
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

        return ProductTypeWithCategoryModel(
          id: productType.id,
          name: productType.name,
          categoryId: productType.categoryId,
          categoryName: category.name,
        );
      }).toList();
    });
  }
}
