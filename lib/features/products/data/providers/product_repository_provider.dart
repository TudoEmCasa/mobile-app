import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/lots/data/providers/lot_repository_provider.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  final lotRepository = ref.watch(lotRepositoryProvider);
  return ProductRepository(database, lotRepository);
});

final watchAllProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.watchProducts();
});
