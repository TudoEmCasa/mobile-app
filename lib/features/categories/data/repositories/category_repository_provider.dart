import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart'
    if (dart.library.html) 'package:tudo_em_casa/features/categories/data/repositories/category_repository_web.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository_provider_native.dart'
    if (dart.library.html) 'package:tudo_em_casa/features/categories/data/repositories/category_repository_provider_web.dart';

/// Provides a singleton instance of [CategoryRepository].
final categoryRepositoryProvider = Provider<CategoryRepository>(
  createCategoryRepository,
);
