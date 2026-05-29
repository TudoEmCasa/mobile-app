import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/services/export/data_export_service.dart';
import 'package:tudo_em_casa/features/categories/data/providers/category_repository_provider.dart';
import 'package:tudo_em_casa/features/product_types/data/providers/product_type_repository_provider.dart';
import 'package:tudo_em_casa/features/products/data/providers/product_repository_provider.dart';
import 'package:tudo_em_casa/features/units/data/providers/unit_repository_provider.dart';

final dataExportServiceProvider = Provider<DataExportService>((ref) {
  return DataExportService(
    categoryRepository: ref.watch(categoryRepositoryProvider),
    productTypeRepository: ref.watch(productTypeRepositoryProvider),
    unitRepository: ref.watch(unitRepositoryProvider),
    productRepository: ref.watch(productRepositoryProvider),
    saveFile: FilePicker.saveFile,
  );
});
