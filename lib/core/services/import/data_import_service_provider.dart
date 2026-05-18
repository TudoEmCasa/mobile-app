import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/core/services/import/data_import_service.dart';
import 'package:tudo_em_casa/features/categories/data/providers/category_repository_provider.dart';
import 'package:tudo_em_casa/features/product_types/data/providers/product_type_repository_provider.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';
import 'package:tudo_em_casa/features/units/data/providers/unit_repository_provider.dart';

final dataImportServiceProvider = Provider<DataImportService>((ref) {
  return DataImportService(
    database: ref.watch(appDatabaseProvider),
    categoryRepository: ref.watch(categoryRepositoryProvider),
    productTypeRepository: ref.watch(productTypeRepositoryProvider),
    unitRepository: ref.watch(unitRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
  );
});
