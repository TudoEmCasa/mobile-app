import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/repositories/index.dart';

final unitRepositoryProvider = Provider<UnitRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return UnitRepository(database);
});

final watchAllUnitsProvider = StreamProvider<List<UnitModel>>((ref) {
  final repository = ref.watch(unitRepositoryProvider);
  return repository.watchUnits();
});
