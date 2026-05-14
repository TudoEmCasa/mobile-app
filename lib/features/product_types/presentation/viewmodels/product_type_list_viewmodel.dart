import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/product_types/data/models/index.dart';
import 'package:tudo_em_casa/features/product_types/data/providers/index.dart';

class ProductTypeListViewModel {
  final Ref _ref;

  ProductTypeListViewModel(this._ref);

  Future<int> createProductType(String name, int categoryId) {
    final repository = _ref.read(productTypeRepositoryProvider);
    return repository.createProductType(name, categoryId);
  }
}

final productTypeListViewModelProvider =
    Provider<ProductTypeListViewModel>((ref) {
  return ProductTypeListViewModel(ref);
});

final productTypesStreamProvider =
    StreamProvider<List<ProductTypeWithCategoryModel>>((ref) {
  return ref.watch(watchAllProductTypesProvider).when(
    data: (productTypes) async* {
      yield productTypes;
    },
    loading: () async* {
      yield const [];
    },
    error: (error, stackTrace) {
      throw error;
    },
  );
});
