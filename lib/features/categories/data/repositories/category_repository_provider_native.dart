import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/database_provider.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';

CategoryRepository createCategoryRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);

  return CategoryRepository(db);
}
