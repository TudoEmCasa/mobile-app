import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/lots/data/models/index.dart';
import 'package:tudo_em_casa/features/lots/data/repositories/lot_repository.dart';

final lotRepositoryProvider = Provider<LotRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return LotRepository(database);
});

final watchAllLotsProvider = StreamProvider<List<LotModel>>((ref) {
  final repository = ref.watch(lotRepositoryProvider);
  return repository.watchLots();
});

final watchLotsByProductIdProvider = StreamProvider.family<List<LotModel>, int>(
  (ref, productId) {
    final repository = ref.watch(lotRepositoryProvider);
    return repository.watchLotsByProductId(productId);
  },
);
