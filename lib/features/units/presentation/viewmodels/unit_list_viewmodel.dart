import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/providers/index.dart';

class UnitListViewModel {
  final Ref _ref;

  UnitListViewModel(this._ref);

  Future<int> createUnit(String name, String symbol) {
    final repository = _ref.read(unitRepositoryProvider);
    return repository.createUnit(name, symbol);
  }

  Future<bool> updateUnit(UnitModel unit) {
    final repository = _ref.read(unitRepositoryProvider);
    return repository.updateUnit(unit);
  }

  Future<bool> deleteUnit(int id) {
    final repository = _ref.read(unitRepositoryProvider);
    return repository.deleteUnit(id);
  }
}

final unitListViewModelProvider = Provider<UnitListViewModel>((ref) {
  return UnitListViewModel(ref);
});

final unitsStreamProvider = StreamProvider<List<UnitModel>>((ref) {
  return ref
      .watch(watchAllUnitsProvider)
      .when(
        data: (units) async* {
          yield units;
        },
        loading: () async* {
          yield const [];
        },
        error: (error, stackTrace) {
          throw error;
        },
      );
});
