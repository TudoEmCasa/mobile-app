import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/products/data/models/index.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';

class ProductListViewModel {
  final Ref _ref;

  ProductListViewModel(this._ref);

  Future<int> createProduct(ProductModel product) {
    final repository = _ref.read(productRepositoryProvider);

    return repository.createProduct(
      name: product.name,
      productTypeId: product.productTypeId,
      unitId: product.unitId,
      quantity: product.quantity,
      expirationDate: product.expirationDate,
    );
  }

  Future<bool> updateProduct(ProductModel product) {
    final repository = _ref.read(productRepositoryProvider);
    return repository.updateProduct(product);
  }

  Future<ProductModel> consumeProductQuantity({
    required int productId,
    required double quantity,
  }) {
    final repository = _ref.read(productRepositoryProvider);

    return repository.consumeProductQuantity(
      productId: productId,
      quantity: quantity,
    );
  }

  Future<bool> deleteProduct(int id) {
    final repository = _ref.read(productRepositoryProvider);
    return repository.deleteProduct(id);
  }
}

final productListViewModelProvider = Provider<ProductListViewModel>((ref) {
  return ProductListViewModel(ref);
});

final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref
      .watch(watchAllProductsProvider)
      .when(
        data: (items) async* {
          yield items;
        },
        loading: () async* {
          yield const [];
        },
        error: (error, stack) {
          throw error;
        },
      );
});
