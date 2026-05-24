import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';

final productStreamProvider = StreamProvider.family<ProductModel?, int>((
  ref,
  productId,
) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.watchProductById(productId);
});
