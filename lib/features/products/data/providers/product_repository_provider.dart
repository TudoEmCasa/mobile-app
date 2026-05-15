import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return ProductRepository(database);
});

final watchAllProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.watchProducts();
});
