import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/lots/data/providers/index.dart';

class LotListViewModel {
  final Ref _ref;

  LotListViewModel(this._ref);

  Future<int> createLot(LotModel lot) {
    final repository = _ref.read(lotRepositoryProvider);
    return repository.createLot(lot);
  }

  Future<bool> updateLot(LotModel lot) {
    final repository = _ref.read(lotRepositoryProvider);
    return repository.updateLot(lot);
  }

  Future<bool> deleteLot(int id) {
    final repository = _ref.read(lotRepositoryProvider);
    return repository.deleteLot(id);
  }

  Future<LotModel> addLotQuantity({
    required int lotId,
    required double quantity,
  }) {
    final repository = _ref.read(lotRepositoryProvider);
    return repository.addLotQuantity(lotId: lotId, quantity: quantity);
  }

  Future<LotModel> consumeLotQuantity({
    required int lotId,
    required double quantity,
  }) {
    final repository = _ref.read(lotRepositoryProvider);
    return repository.consumeLotQuantity(lotId: lotId, quantity: quantity);
  }
}

final lotListViewModelProvider = Provider<LotListViewModel>((ref) {
  return LotListViewModel(ref);
});

final lotsStreamProvider = StreamProvider<List<LotModel>>((ref) {
  return ref
      .watch(watchAllLotsProvider)
      .when(
        data: (lots) async* {
          yield lots;
        },
        loading: () async* {
          yield const [];
        },
        error: (error, stackTrace) {
          throw error;
        },
      );
});

final lotsByProductIdStreamProvider =
    StreamProvider.family<List<LotModel>, int>((ref, productId) {
      return ref
          .watch(watchLotsByProductIdProvider(productId))
          .when(
            data: (lots) async* {
              yield lots;
            },
            loading: () async* {
              yield const [];
            },
            error: (error, stackTrace) {
              throw error;
            },
          );
    });
