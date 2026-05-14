import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';

final productTypeRepositoryProvider = Provider<ProductTypeRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ProductTypeRepository(database);
});

final watchAllProductTypesProvider =
    StreamProvider<List<ProductTypeWithCategoryModel>>((ref) {
      final repository = ref.watch(productTypeRepositoryProvider);
      return repository.watchProductTypes();
    });
