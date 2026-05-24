import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/lots/data/repositories/lot_repository.dart';

final lotRepositoryProvider = Provider<LotRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return LotRepository(database);
});
